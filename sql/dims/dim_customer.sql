-- Dimension client.
-- Grain: one current row per customer_id for S02.

CREATE OR REPLACE TABLE dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    first_name || ' ' || last_name AS full_name,
    email_domain,
    city,
    province,
    loyalty_segment,
    CAST(join_date AS DATE) AS join_date,
    CAST(join_date AS DATE) AS effective_from,
    CAST('9999-12-31' AS DATE) AS effective_to,
    TRUE AS is_current
FROM raw_dim_customer
WHERE customer_id IS NOT NULL;

