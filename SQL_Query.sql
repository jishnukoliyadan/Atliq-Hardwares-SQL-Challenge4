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

-- # 5. Get the products that have the highest and lowest manufacturing costs.
-- SELECT fc.product_code, product, manufacturing_cost FROM fact_manufacturing_cost as fc
--     JOIN dim_product as dp
--     ON fc.product_code = dp.product_code
--     WHERE fc.manufacturing_cost = (SELECT max(manufacturing_cost) FROM fact_manufacturing_cost) OR
--         fc.manufacturing_cost = (SELECT min(manufacturing_cost) FROM fact_manufacturing_cost)
--     ORDER BY manufacturing_cost DESC;

# ----------------------------------------------------------------------------------------------------------------------- #

-- # 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the
-- #    fiscal year 2021 and in the Indian market.
-- SELECT fd.customer_code, customer, pre_invoice_discount_pct FROM fact_pre_invoice_deductions fd
--     JOIN dim_customer dc
--     ON fd.customer_code = dc.customer_code
--     WHERE market = "India"
--     ORDER BY pre_invoice_discount_pct DESC
--     LIMIT 5;

# ----------------------------------------------------------------------------------------------------------------------- #

# 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month.
#    This analysis helps to get an idea of low and high-performing months and take strategic decisions.
WITH gross_sales_table AS (
        SELECT date, fm.customer_code, fp.fiscal_year, gross_price * sold_quantity AS gross_sales FROM fact_gross_price fp
            JOIN fact_sales_monthly fm
            ON fm.product_code = fp.product_code
            AND fm.fiscal_year = fp.fiscal_year),

    customer_sort AS (
        SELECT date, dc.customer_code, gross_sales FROM gross_sales_table gt
            JOIN dim_customer dc
            ON gt.customer_code = dc.customer_code
            WHERE customer = "Atliq Exclusive")

SELECT MONTH(date) AS Month, YEAR(date) AS Year, ROUND(SUM(gross_sales) / 1000000, 2) AS Gross_sales_Amount FROM customer_sort
        GROUP BY Month, Year;