# Rétroaction automatisée -- S01 (Diagnostic fondamental -- NexaMart kickoff)

_Générée le 2026-05-14T22:57:46+00:00 -- Run `20260514T221333Z-7d34bf6a`_

Ce document est produit par un pipeline reproductible (vérification SQL déterministe + analyse LLM du brief et de la déclaration IA). Une revue humaine précède toujours sa publication. **À ce stade expérimental, aucune note ni étiquette de niveau n'est diffusée : l'objectif est purement formatif.**

---

## 1. Vérification automatique de la requête SQL

La requête extraite de votre brief n'a pas pu être validée automatiquement. Quelques pistes constructives ci-dessous pour vous aider à la rendre exécutable et alignee avec la question posée.

_Observation technique : erreur d'exécution SQL: Catalog Error: Table with name fact_sales does not exist!_

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
> Votre `db/nexamart.duckdb` est absente ou vide ; la requête a été exécutée contre une **base de référence cohorte** (seed instructeur). Les chiffres retournés ne correspondent donc pas à vos propres données : reconstruisez votre base avec `python src/run_pipeline.py` (ou `.\run.ps1 load`) pour valider vos calculs sur votre seed personnel.
> Tables référencées dans votre requête mais absentes de la base : `dim_date`, `dim_product`, `dim_store`, `fact_sales`.
> Tables disponibles dans `db/nexamart.duckdb` : `raw_bridge_campaign_allocation`, `raw_bridge_customer_segment`, `raw_customer_changes`, `raw_customer_profile_bands`, `raw_customer_scd3_history`, `raw_dim_channel`, `raw_dim_customer`, `raw_dim_date`, `raw_dim_geography`, `raw_dim_product`, `raw_dim_segment_outrigger`, `raw_dim_store`, `raw_fact_budget`, `raw_fact_daily_inventory`, `raw_fact_inventory_snapshot`, `raw_fact_order_pipeline`, `raw_fact_orders_transaction`, `raw_fact_promo_exposure`, `raw_fact_returns`, `raw_fact_sales`.
> Pour `dim_date`, peut-être vouliez-vous : `raw_dim_date` ?
> Pour `dim_product`, peut-être vouliez-vous : `raw_dim_product` ?
> Pour `dim_store`, peut-être vouliez-vous : `raw_dim_store` ?
> Pour `fact_sales`, peut-être vouliez-vous : `raw_fact_sales` ?

## 2. Rétroaction pédagogique sur le brief

_La rétroaction détaillée n'a pas pu être générée (LLM indisponible: openai: Connection error.)._

Vous pouvez relancer le grader local (`tools/grader/grade_brief.py`) pour obtenir une vue indicative.

## 3. Déclaration d'utilisation de l'IA

_La déclaration n'a pas pu être analysée (Évaluation IA-usage non effectuée: openai: Connection error.)._

## 4. Pistes d'action pour la prochaine itération

- Reprendre la requête de la section « Preuve » pour qu'elle s'exécute sur `db/nexamart.duckdb` et qu'elle produise la forme attendue (voir pistes en section 1).

---

## 5. Traçabilité

- **Run ID :** `20260514T221333Z-7d34bf6a`
- **Devoir :** `S01`
- **Étudiant·e :** `v2-GenevievePelletierBrodeur`
- **Commit analysé :** `e35c9eb`
- **Audit (côté instructeur) :** `tools/instructor/feedback_pipeline/audit/20260514T221333Z-7d34bf6a/v2-GenevievePelletierBrodeur/`
- **Prompts (SHA-256) :**
  - `sql_extractor_system` : `90ee9e277de7a27f...`
  - `rubric_grader_system` : `505f32d1d8319d66...`
  - `ai_usage_grader_system` : `81cb7fdf89bda55a...`
- **Fournisseur (IA-usage) :** `fallback` (?)

_Ce feedback a été produit par un pipeline automatisé et **revu par l'équipe pédagogique avant publication**. Aucun chiffre ni étiquette de niveau n'est diffusé à ce stade expérimental : l'objectif est uniquement formatif. Ouvrez une issue dans ce dépôt pour toute question._
