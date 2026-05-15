# Rétroaction automatisée -- S01 (Diagnostic fondamental -- NexaMart kickoff)

_Générée le 2026-05-15T12:30:37+00:00 -- Run `20260515T122624Z-00a5a04f`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

> ⚠️ **Avertissement instructeur (à retirer avant publication) :** cette analyse a été générée avec `--skip-pull`. Le contenu correspond au commit local et **n'est peut-être pas la dernière version poussée par l'étudiant·e**.

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : erreur d'exécution SQL: Binder Error: Table "f" does not have a column named "product_id"_

<details><summary>Requête analysée — cliquez pour déplier</summary>

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

</details>


**Pistes :**
> Tables disponibles dans `db/nexamart.duckdb` : `dim_channel`, `dim_customer`, `dim_date`, `dim_product`, `dim_store`, `fact_sales`, `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`, `raw_dim_customer`, `raw_dim_date`, `raw_dim_geography`, `raw_dim_product`, `raw_dim_segment_outrigger`, `raw_dim_store`, `raw_fact_budget`, `raw_fact_daily_inventory`.

## 2. Rétroaction pédagogique sur le brief

> Très bon diagnostic technique et métier : grain expliqué, dimensions listées, SQL de validation et recommandations d'architecture claires. Il manque toutefois la traçabilité des décisions (commits/IA) et des artefacts reproductibles pour une livraison prête à l'usage.

### Observations par dimension

**Model quality**
- Observation : Le brief précise le grain (« sale_line_id »), décrit 5 dimensions (dim_product, dim_store, dim_date, dim_channel, dim_customer) et justifie l'usage d'un entrepôt historisé pour éviter les biais des jointures ad‑hoc.
- Piste d'amélioration : Ajouter un diagramme schématique (étoile) avec clés primaires/étrangères et indiquer explicitement les attributs SCD (date_debut/date_fin) pour dim_product et dim_store.

**Validation quality**
- Observation : Le brief fournit une requête SQL qui calcule rev_2024 vs rev_2025, explique pourquoi l'exécution retourne 0 lignes et propose une vérification alternative QoQ ainsi qu'une checklist de contrôles (grain, NULLs, complétude temporelle).
- Piste d'amélioration : Fournir des snippets de checks exécutables (ex. COUNT(*) pour range de dates, check d'unicité (order_number, sale_line_id)) et inclure les résultats bruts des contrôles.

**Executive justification**
- Observation : La section 'Réponse exécutive' explique en langage métier que l'entrepôt doit enrichir les ventes pour produire une source de vérité partagée et que la requête ad‑hoc est conceptuellement fragile pour répondre au CEO.
- Piste d'amélioration : Condenser la recommandation en une décision claire à prendre par le CEO (p. ex. 'Approuver la construction SCD2 pour dim_product et dim_store et financer S02') pour faciliter l'action immédiate.

**Process trace**
- Observation : Aucune mention d'historique git, de commits, ni de note d'utilisation d'IA ou de journal de décision n'apparaît dans le brief.
- Piste d'amélioration : Ajouter un court historique de commits (≥3) avec messages et une note IA précisant outils/usage et confirmation de validation humaine.

**Reproducibility**
- Observation : Le brief ne contient pas d'instructions de reproduction, de README ou de script 'make check' exécutable pour reproduire les résultats.
- Piste d'amélioration : Inclure un README minimal et un script check (ou commandes DuckDB) permettant de reproduire la requête et les contrôles sur un clone propre.

## 3. Déclaration d'utilisation de l'IA

> La déclaration couvre les étapes, la validation humaine et les limites observées de façon explicite. Toutefois, la mention des outils est incomplète (GitHub Copilot sans version) et certaines validations sont laissées «À compléter», ce qui rend la description partiellement générique.

**Sujets bien couverts dans votre déclaration :**

- à quelle étape l'IA a été utilisée
- comment la sortie a été validée par l'humain
- limites ou erreurs observées

**Sujets à ajouter ou expliciter pour la prochaine itération :**

- outils utilisés (nom + version/modèle)

## 4. Pistes d'action pour la prochaine itération

- Reprendre la requête de la section « Preuve » pour qu'elle s'exécute sur `db/nexamart.duckdb` et qu'elle produise la forme attendue (voir pistes en section 1).

---

## 5. Traçabilité

- **Run ID :** `20260515T122624Z-00a5a04f`
- **Devoir :** `S01`
- **Étudiant·e :** `GenevievePelletierBrodeur`
- **Commit analysé :** `a63ee39`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260515T122624Z-00a5a04f/GenevievePelletierBrodeur/`
- **Prompts (SHA-256) :**
  - `sql_extractor_system` : `90ee9e277de7a27f...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (rubrique) :** `openai`
- **Fournisseur (IA-usage) :** `openai` (gpt-5-mini-2025-08-07)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
