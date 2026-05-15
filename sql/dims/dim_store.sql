-- Dimension magasin.
-- Grain: one row per store_id.

CREATE OR REPLACE TABLE dim_store AS
SELECT
    ROW_NUMBER() OVER (ORDER BY store_id) AS store_key,
    store_id,
    store_name,
    city,
    region,
    province,
    store_type
FROM raw_dim_store
WHERE store_id IS NOT NULL;

