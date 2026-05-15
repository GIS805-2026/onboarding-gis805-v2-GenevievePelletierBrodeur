# Schema v1 — NexaMart Star Schema

## Objectif

Ce schema v1 modele le processus principal de vente de NexaMart. Il permet de
repondre de facon repetable a la question CEO :

> Quelles categories de produits declinent dans quelles regions, par trimestre ?

## Grain

**Une ligne de `fact_sales` = une ligne de commande**, identifiee par
`sale_line_id` et contextualisee par `order_number`.

## Tables

| Table | Role | Cle principale |
|---|---|---|
| `fact_sales` | Mesures de vente au grain ligne de commande | `sale_line_id` |
| `dim_date` | Axe temporel | `date_key` |
| `dim_product` | Categorie et attributs produit | `product_key` |
| `dim_store` | Region et attributs magasin | `store_key` |
| `dim_customer` | Client et segment de fidelite | `customer_key` |
| `dim_channel` | Canal de vente | `channel_key` |

## Diagramme Mermaid

Source autonome : `diagrams/schema-v1.mmd`.

```mermaid
erDiagram
    DIM_DATE ||--o{ FACT_SALES : "order_date"
    DIM_PRODUCT ||--o{ FACT_SALES : "product_key"
    DIM_STORE ||--o{ FACT_SALES : "store_key"
    DIM_CUSTOMER ||--o{ FACT_SALES : "customer_key"
    DIM_CHANNEL ||--o{ FACT_SALES : "channel_key"

    FACT_SALES {
        int sale_line_id PK
        string order_number "degenerate dim"
        date order_date FK
        int customer_key FK
        int product_key FK
        int store_key FK
        int channel_key FK
        int quantity "additive"
        decimal unit_price "non-additive"
        decimal discount_pct "non-additive"
        decimal net_price "additive"
        decimal line_total "additive"
        decimal margin_amount "additive"
    }

    DIM_DATE {
        date date_key PK
        date full_date
        int year
        int quarter
        int month
        string month_name
        string year_month "conforming"
        int week_iso
        int day_of_week
        string day_name
        boolean is_weekend
    }

    DIM_PRODUCT {
        int product_key PK
        string product_id
        string product_name
        string category
        string subcategory
        string brand
        decimal unit_cost
        decimal unit_price
    }

    DIM_STORE {
        int store_key PK
        string store_id
        string store_name
        string city
        string region "conforming"
        string province
        string store_type
    }

    DIM_CUSTOMER {
        int customer_key PK
        string customer_id
        string full_name
        string email_domain
        string city
        string province
        string loyalty_segment "SCD2"
        date join_date
        date effective_from
        date effective_to
        boolean is_current
    }

    DIM_CHANNEL {
        int channel_key PK
        string channel_id
        string channel_name
        string channel_type
    }
```

## Preuve analytique

La requete `sql/analysis/s02-first-answer.sql` joint `fact_sales` a
`dim_product`, `dim_store` et `dim_date`, puis retourne les ventes par
categorie, region et trimestre avec une lecture de tendance.
