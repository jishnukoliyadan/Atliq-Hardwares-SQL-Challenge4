USE gdb023;

# 1. The list of markets in which customer "Atliq Exclusive" operates its business in the APAC region
SELECT DISTINCT(market) FROM dim_customer
    WHERE region = 'APAC' AND customer = 'Atliq Exclusive';