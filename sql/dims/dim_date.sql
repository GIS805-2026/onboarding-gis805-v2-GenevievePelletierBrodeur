-- Dimension date.
-- Grain: one row per calendar date.

CREATE OR REPLACE TABLE dim_date AS
SELECT
    CAST(date_key AS DATE) AS date_key,
    CAST(date_key AS DATE) AS full_date,
    CAST(year AS INTEGER) AS year,
    CAST(quarter AS INTEGER) AS quarter,
    CAST(month AS INTEGER) AS month,
    month_name,
    CAST(year AS VARCHAR) || '-' || LPAD(CAST(month AS VARCHAR), 2, '0') AS year_month,
    CAST(week_iso AS INTEGER) AS week_iso,
    CAST(day_of_week AS INTEGER) AS day_of_week,
    day_name,
    CAST(is_weekend AS BOOLEAN) AS is_weekend
FROM raw_dim_date
WHERE date_key IS NOT NULL;

