-- S02 first answer
-- CEO question: Which product categories decline in which regions, by quarter?
--
-- This query proves the star schema works because the answer requires:
--   - fact_sales.line_total for revenue
--   - dim_product.category for the product category
--   - dim_store.region for the geographic region
--   - dim_date.year and dim_date.quarter for the time period

WITH quarterly_sales AS (
    SELECT
        p.category,
        s.region,
        d.year,
        d.quarter,
        SUM(f.line_total) AS total_revenue,
        COUNT(*) AS sales_lines
    FROM fact_sales f
    JOIN dim_product p
        ON p.product_key = f.product_key
    JOIN dim_store s
        ON s.store_key = f.store_key
    JOIN dim_date d
        ON d.date_key = f.order_date
    GROUP BY
        p.category,
        s.region,
        d.year,
        d.quarter
),
quarterly_trends AS (
    SELECT
        category,
        region,
        year,
        quarter,
        total_revenue,
        sales_lines,
        LAG(total_revenue) OVER (
            PARTITION BY category, region, year
            ORDER BY quarter
        ) AS previous_quarter_revenue
    FROM quarterly_sales
)
SELECT
    category,
    region,
    year,
    quarter,
    total_revenue,
    previous_quarter_revenue,
    total_revenue - previous_quarter_revenue AS revenue_delta,
    sales_lines,
    CASE
        WHEN previous_quarter_revenue IS NULL THEN 'first_quarter'
        WHEN total_revenue < previous_quarter_revenue THEN 'declining'
        WHEN total_revenue > previous_quarter_revenue THEN 'growing'
        ELSE 'flat'
    END AS trend_status
FROM quarterly_trends
ORDER BY
    category,
    region,
    year,
    quarter;

