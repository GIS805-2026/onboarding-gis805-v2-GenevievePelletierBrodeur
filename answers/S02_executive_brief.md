# Board Brief — S02 : Star Schema v1

## Question du CEO

Quelles catégories de produits déclinent dans quelles régions, par trimestre ?

## Réponse exécutive

Le schéma en étoile v1 de NexaMart rend cette question répétable : les ventes sont
centralisées dans `fact_sales`, puis enrichies par `dim_product` pour la catégorie,
`dim_store` pour la région et `dim_date` pour le trimestre.

Sur les données chargées, plusieurs combinaisons catégorie × région montrent un
déclin d'un trimestre au suivant. Les plus fortes baisses observées sont notamment
`Books & Media` en `Ontario` au T3 2025 (-6111.62), puis `Automotive` en `Ontario`
au T2 et T3 2025. Ces résultats donnent au CEO une liste priorisée de zones à
investiguer plutôt qu'un simple total de ventes global.

## Grain statement

**Une ligne de `fact_sales` = une ligne de commande**, identifiée par
`sale_line_id` et contextualisée par la dimension dégénérée `order_number`.

Ce grain est assez fin pour analyser les ventes par produit, catégorie, magasin,
région, canal et trimestre. Les questions plus haut niveau, comme les ventes par
catégorie × région × trimestre, sont obtenues par agrégation.

## Schéma en étoile construit

Le schéma v1 est documenté dans :

- `docs/schema-v1.md`
- `diagrams/schema-v1.mmd`
- `Diagrams/nexamart-star-schema.drawio`

Tables principales :

- `fact_sales` : ventes au grain ligne de commande.
- `dim_product` : catégorie, sous-catégorie, marque.
- `dim_store` : ville, province, région.
- `dim_date` : année, trimestre, mois, semaine.
- `dim_customer` : client, segment de fidélité, dates SCD2.
- `dim_channel` : canal de vente.

## Preuve SQL

La requête de preuve est dans `sql/analysis/s02-first-answer.sql`.

Elle joint `fact_sales` aux dimensions nécessaires, agrège les ventes par
catégorie, région et trimestre, puis compare chaque trimestre au trimestre
précédent avec `LAG()`.

```sql
WITH quarterly_sales AS (
    SELECT
        p.category,
        s.region,
        d.year,
        d.quarter,
        SUM(f.line_total) AS total_revenue,
        COUNT(*) AS sales_lines
    FROM fact_sales f
    JOIN dim_product p ON p.product_key = f.product_key
    JOIN dim_store s ON s.store_key = f.store_key
    JOIN dim_date d ON d.date_key = f.order_date
    GROUP BY p.category, s.region, d.year, d.quarter
)
SELECT
    category,
    region,
    year,
    quarter,
    total_revenue
FROM quarterly_sales;
```

La version complète ajoute `previous_quarter_revenue`, `revenue_delta` et
`trend_status`.

## Résultat observé

Top 10 des déclins trimestriels les plus forts :

| category | region | year | quarter | total_revenue | previous_quarter_revenue | revenue_delta | sales_lines | trend_status |
|---|---|---:|---:|---:|---:|---:|---:|---|
| Books & Media | Ontario | 2025 | 3 | 11845.53 | 17957.15 | -6111.62 | 38 | declining |
| Automotive | Ontario | 2025 | 2 | 11571.20 | 17195.00 | -5623.80 | 34 | declining |
| Automotive | Ontario | 2025 | 3 | 6998.56 | 11571.20 | -4572.64 | 20 | declining |
| Automotive | Alberta | 2025 | 3 | 7148.45 | 11423.09 | -4274.64 | 18 | declining |
| Books & Media | Alberta | 2025 | 4 | 4923.23 | 9091.76 | -4168.53 | 16 | declining |
| Pet Supplies | Québec | 2025 | 2 | 4257.91 | 7908.60 | -3650.69 | 14 | declining |
| Pet Supplies | Ontario | 2025 | 2 | 5996.72 | 9561.93 | -3565.21 | 17 | declining |
| Toys & Games | Ontario | 2025 | 2 | 9172.32 | 12071.25 | -2898.93 | 29 | declining |
| Sports & Outdoors | Ontario | 2025 | 3 | 3537.29 | 6315.86 | -2778.57 | 23 | declining |
| Grocery | Estrie | 2025 | 3 | 1269.27 | 3990.35 | -2721.08 | 8 | declining |

## Validation

- `make load` crée les dimensions et `fact_sales` sans erreur.
- `fact_sales` contient 3850 lignes, soit le même volume que `raw_fact_sales`.
- La requête `sql/analysis/s02-first-answer.sql` s'exécute dans DuckDB sans erreur.
- Les résultats retournent bien le grain demandé par la rubrique :
  catégorie × région × trimestre.
- Les clés de jointure utilisées sont les clés substituts `*_key`, pas les clés
  naturelles `*_id`.

## Décision de modélisation

Le choix de grain est documenté dans `docs/decision-log.md`, décision `D01`.

J'ai choisi le grain ligne de commande parce qu'il préserve la catégorie produit.
Un grain au niveau en-tête de commande aurait masqué les produits achetés dans une
même commande, donc il aurait rendu la question CEO moins fiable.

## Limites

- Les données disponibles couvrent surtout une comparaison intra-année 2025 :
  le déclin est donc lu comme une baisse trimestre sur trimestre, pas comme une
  baisse annuelle.
- Les résultats indiquent où investiguer, mais pas encore pourquoi les ventes
  déclinent. Les causes possibles devront être croisées avec les retours, le budget,
  l'inventaire et les campagnes dans les séances suivantes.

## Recommandation

Prioriser l'analyse de `Books & Media` en Ontario au T3 2025 et de `Automotive`
en Ontario au T2-T3 2025. Ces combinaisons présentent les baisses les plus fortes
et méritent une investigation sur les retours, la disponibilité produit et les
changements de demande régionale.
