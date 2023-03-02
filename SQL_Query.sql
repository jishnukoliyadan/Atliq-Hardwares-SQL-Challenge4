-- USE gdb023;

-- # 1. The list of markets in which customer "Atliq Exclusive" operates its business in the APAC region
-- SELECT DISTINCT(market) FROM dim_customer
--     WHERE region = 'APAC' AND customer = 'Atliq Exclusive';

# ----------------------------------------------------------------------------------------------------------------------- #

-- # 2. What is the percentage of unique product increase in 2021 vs. 2020?
-- WITH fy20 AS (
--         SELECT COUNT(DISTINCT(product_code)) AS up_20 FROM fact_sales_monthly
--             WHERE fiscal_year = 2020),
            
--     fy21 AS (
--         SELECT COUNT(DISTINCT(product_code)) AS up_21 FROM fact_sales_monthly
--             WHERE fiscal_year = 2021)
            
-- SELECT fy20.up_20 AS unique_products_2020,
--     fy21.up_21 AS unique_products_2021,
--     ROUND((fy21.up_21-fy20.up_20) * 100/fy20.up_20, 2) as percentage_chg
--     FROM fy20, fy21;

# ----------------------------------------------------------------------------------------------------------------------- #

-- # 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
-- SELECT segment, count(product) AS product_count FROM dim_product
--     GROUP BY segment
--     ORDER BY product_count DESC;

# ----------------------------------------------------------------------------------------------------------------------- #

-- # 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020?
-- WITH fy20 AS(
--         SELECT segment, COUNT(DISTINCT(fm.product_code)) AS seg20 FROM fact_sales_monthly fm
--             JOIN dim_product dp
--             ON fm.product_code = dp.product_code
--             WHERE fiscal_year = 2020
--             GROUP BY dp.segment),
            
--     fy21 AS(
--         SELECT segment, COUNT(DISTINCT(fm.product_code)) AS seg21 FROM fact_sales_monthly fm
--             JOIN dim_product dp
--             ON fm.product_code = dp.product_code
--             WHERE fiscal_year = 2021
--             GROUP BY dp.segment)
            
-- SELECT fy20.segment, seg20 AS product_count_2020, seg21 AS product_count_2021, seg21-seg20 AS difference FROM fy20
--     JOIN fy21
--     ON fy20.segment = fy21.segment
--     ORDER BY difference DESC;

# ----------------------------------------------------------------------------------------------------------------------- #

# 5. Get the products that have the highest and lowest manufacturing costs.
SELECT fc.product_code, product, manufacturing_cost FROM fact_manufacturing_cost as fc
    JOIN dim_product as dp
    ON fc.product_code = dp.product_code
    WHERE fc.manufacturing_cost = (SELECT max(manufacturing_cost) FROM fact_manufacturing_cost) OR
        fc.manufacturing_cost = (SELECT min(manufacturing_cost) FROM fact_manufacturing_cost)
    ORDER BY manufacturing_cost DESC;