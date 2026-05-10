# Board Brief — S01

## Question du CEO
Quelles catégories déclinent dans quelles régions et pourquoi ?


## Réponse exécutive
La table de ventes seule ne contient que des codes (PRD-0083, STR-001). Pour répondre à la question du CEO, je dois enrichir chaque vente avec ses attributs descriptifs : la catégorie du produit, la région du magasin, le canal, la période. Cet enrichissement, c'est le travail de l'entrepôt — pré-relier les codes à leurs dimensions, une fois pour toutes, de façon auditable et partagée. Sans ça, chaque analyste recoderait sa propre vérité, et nos rapports diverger aient.


## Décisions de modélisation
Table de faits : fact_sales (2 939 lignes)
Grain : Une ligne = Une ligne de fact_sales = une ligne de commande individuelle, identifiée par sale_line_id

J'ai 1 table de faits (fact_sales) et 5 dimensions (dim_date, dim_product, dim_store, dim_customer, dim_channel).
5 dimensions:
dim_product (catégorie, sous-catégorie, marque) — « quoi »
dim_store (région, province, store_type) — « où »
dim_date (year, quarter, month) — « quand »
dim_channel (channel_type online/physical/phone)
dim_customer (loyalty_segment)

Mesures : quantity, net_price, line_total (mesure de revenu primaire), discount_pct

Hypothèse de travail : « décliner » = revenu (SUM(line_total)) en baisse 2025 vs 2024 sur la même période (Jan–Déc complète, donc années comparables).

L'entrepot n'est pas l'OLTP. L'OLTP est la mémoire à court terme de l'entreprise. L'OLAP est sa mémoire à long terme. Les deux sont essentielles, mais elles n'ont pas le droit d'habiter dans la même tête.


## Preuve

La requête logique qui répondrait à la question CEO est :

```sql
SELECT
    p.category,
    s.region,
    SUM(CASE WHEN d.year = 2024 THEN f.line_total END) AS rev_2024,
    SUM(CASE WHEN d.year = 2025 THEN f.line_total END) AS rev_2025,
    SUM(CASE WHEN d.year = 2025 THEN f.line_total END)
      - SUM(CASE WHEN d.year = 2024 THEN f.line_total END) AS delta
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store   s ON f.store_id   = s.store_id
JOIN dim_date    d ON f.order_date = d.date_key
GROUP BY p.category, s.region
HAVING SUM(CASE WHEN d.year = 2024 THEN f.line_total END) >= 5000
   AND (SUM(CASE WHEN d.year = 2025 THEN f.line_total END)
       - SUM(CASE WHEN d.year = 2024 THEN f.line_total END)) < 0
ORDER BY delta ASC;
```


Cependant, exécuter cette requête aujourd'hui sur les tables source (OLTP) serait techniquement possible mais conceptuellement fragile : les dimensions source (product, store, date) ne sont pas historisées — elles reflètent l'état actuel, pas celui au moment de chaque vente. Comparer une vente de 2024 en utilisant la description d'aujourd'hui du produit / magasin introduit un biais silencieux. De plus, les années 2024–2025 peuvent ne pas être présentes en volume comparable dans une base transactionnelle jeune, ce qui invalide la comparaison.

## Validation

Pour que cette requête soit fiable, il faut d'abord vérifier :

1. Intégrité du grain — Chaque (order_number, sale_line_id) est unique dans fact_sales ? Les jointures conservent-elles le grain (pas de cartésien involontaire) ?
2. Comparabilité temporelle — Les années 2024 et 2025 sont-elles complètes du 1ᵉʳ janvier au 31 décembre dans les données source ? Ou le 2025 s'arrête-t-il à mai (biais de saisonnalité) ?
3. Absence de NULLs silencieux — Y a-t-il des lignes de ventes dont product_id ou store_id ne trouvent aucun match dans les dimensions ? (Elles disparaîtraient du JOIN.)
4. Mesure additive — SUM(line_total) a-t-elle du sens à ce niveau d'agrégation, ou faut-il pondérer par un facteur d'ajustement ?
Aucune de ces vérifications ne peut être menée de manière reproductible sans un schéma d'entrepôt formellement documenté avec métadonnées, tests automatisés, et historique des dimensions.


## Risques / limites

Le problème fondamental : OLTP ≠ OLAP.

L'OLTP source est optimisée pour l'insertion rapide (une commande = une ligne, maintenant).
L'OLAP doit être optimisée pour l'analyse correcte (une commande = une ligne historisée, comparable d'année en année, avec contexte immutable).

Risques concrets :

1. Biais de dimension — Si un magasin change de région entre 2024 et 2025, les requêtes qui comparent par région donnent une réponse qui mélange deux réalités différentes.
2. Données incomplètes — Les entrepôts transactionnels jeunes (< 5 ans) ont souvent un historique court, incomplet ou balancé de manière différente selon l'année. Comparer 2024 vs 2025 peut être faux statistiquement.
3. Aucune traçabilité — Qui a créé ce report ? Quelle version de la logique métier sous-tend la catégorie « Electronics » ? Sans versioning des dimensions, le CEO ne sait pas s'il compare des pommes à des pommes.
4. Fragmentation analytique — Chaque analyste qui veut répondre à « pourquoi » doit réécrire le JOIN, les tests de logique métier, les cas limites. À 10 analystes, 10 vérités divergent.

## Prochaines recommandations

Pour répondre fiablement à la question du CEO, construire un entrepôt OLAP multi-couches :

1. Couche staging (STG) — Importer les sources brutes avec versioning temporel. Documenter chaque extraction.

2. Couche dimensions (DIM) avec historique de type 2 (SCD 2) :
dim_product_v2 : Chaque version d'une catégorie, avec date_debut et date_fin.
dim_store_v2 : Chaque changement de région, avec justification audit.
Cette historique élimine le biais de dimension.

3. Couche faits (FACT) avec grain immutable :
fact_sales_historized : Chaque ligne de vente enrichie au moment du JOIN avec la version historique pertinente des dimensions (product et store à la date de la commande).

4. Couche rapports (RPT) pré-calculée :
Agrégations « déclin par catégorie × région » versionnées, auditées, testées.
Le CEO consulte le rapport, pas la requête ad hoc.

5. Intégration de sources complémentaires (S06+) :
Retours (fact_returns) pour distinguer « baisse de demande » de « taux de retour élevé ».
Stocks (dim_inventory) pour évaluer si le déclin reflète une rupture de stock.
Promotions (dim_promotion) pour contrôler l'effet prix sur le revenu.

Gain immédiat : Chaque analyst utilise le même modèle, le même grain, les mêmes mesures. Le CEO obtient une réponse unique, vérifiable, défendable.