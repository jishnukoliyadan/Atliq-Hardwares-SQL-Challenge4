USE gdb023;

-- # 1. The list of markets in which customer "Atliq Exclusive" operates its business in the APAC region
-- SELECT DISTINCT(market) FROM dim_customer
--     WHERE region = 'APAC' AND customer = 'Atliq Exclusive';

# ----------------------------------------------------------------------------------------------------------------------- #

# 2. What is the percentage of unique product increase in 2021 vs. 2020?
WITH fy20 AS (
        SELECT COUNT(DISTINCT(product_code)) AS up_20 FROM fact_sales_monthly
            WHERE fiscal_year = 2020),
            
    fy21 AS (
        SELECT COUNT(DISTINCT(product_code)) AS up_21 FROM fact_sales_monthly
            WHERE fiscal_year = 2021)
            
SELECT fy20.up_20 AS unique_products_2020,
    fy21.up_21 AS unique_products_2021,
    ROUND((fy21.up_21-fy20.up_20) * 100/fy20.up_20, 2) as percentage_chg
    FROM fy20, fy21;