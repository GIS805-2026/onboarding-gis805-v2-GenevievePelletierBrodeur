-- Table de faits des ventes.
-- Grain: one row per order line, identified by sale_line_id.

CREATE OR REPLACE TABLE fact_sales AS
SELECT
    rs.sale_line_id,
    rs.order_number,
    CAST(rs.order_date AS DATE) AS order_date,

    c.customer_key,
    p.product_key,
    st.store_key,
    ch.channel_key,

    CAST(rs.quantity AS INTEGER) AS quantity,
    CAST(rs.unit_price AS DECIMAL(10, 2)) AS unit_price,
    CAST(rs.discount_pct AS DECIMAL(5, 2)) AS discount_pct,
    CAST(rs.net_price AS DECIMAL(10, 2)) AS net_price,
    CAST(rs.line_total AS DECIMAL(10, 2)) AS line_total,
    CAST((rs.net_price - p.unit_cost) * rs.quantity AS DECIMAL(10, 2)) AS margin_amount
FROM raw_fact_sales rs
JOIN dim_customer c
    ON c.customer_id = rs.customer_id
    AND CAST(rs.order_date AS DATE) BETWEEN c.effective_from AND c.effective_to
JOIN dim_product p
    ON p.product_id = rs.product_id
JOIN dim_store st
    ON st.store_id = rs.store_id
JOIN dim_channel ch
    ON ch.channel_id = rs.channel_id;

