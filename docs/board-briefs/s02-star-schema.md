# Board Brief — S02 Star Schema

## CEO Question

Quelles categories de produits declinent dans quelles regions, par trimestre ?

## Model Answer

Le modele S02 utilise une etoile centree sur `fact_sales`. Le grain choisi est la ligne de commande, ce qui conserve le lien direct entre une vente, un produit, un magasin, un canal, un client et une date.

## Star Schema

- Fait : `fact_sales`
- Dimensions : `dim_date`, `dim_product`, `dim_store`, `dim_customer`,
  `dim_channel`
- Diagramme : `diagrams/schema-v1.mmd`
- Documentation : `docs/schema-v1.md`

## First SQL Answer

La preuve est dans `sql/analysis/s02-first-answer.sql`. La requete retourne les ventes par categorie, region et trimestre, puis identifie les baisses par rapport au trimestre precedent.

## Key Evidence

| category | region | year | quarter | total_revenue | previous_quarter_revenue | revenue_delta |
|---|---|---:|---:|---:|---:|---:|
| Books & Media | Ontario | 2025 | 3 | 11845.53 | 17957.15 | -6111.62 |
| Automotive | Ontario | 2025 | 2 | 11571.20 | 17195.00 | -5623.80 |
| Automotive | Ontario | 2025 | 3 | 6998.56 | 11571.20 | -4572.64 |
| Automotive | Alberta | 2025 | 3 | 7148.45 | 11423.09 | -4274.64 |
| Books & Media | Alberta | 2025 | 4 | 4923.23 | 9091.76 | -4168.53 |

## Board Recommendation

Investiguer d'abord `Books & Media` en Ontario et `Automotive` en Ontario, car ces combinaisons montrent les plus fortes baisses trimestrielles. Les prochaines seances devront croiser ces ventes avec les retours, le budget et l'inventaire pour expliquer le pourquoi du declin.
