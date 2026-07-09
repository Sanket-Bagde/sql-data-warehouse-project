/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.
===============================================================================
*/


-- Checking 'gold.dim_customers'

---- Data Integration 
------ Here , we merge cst_gndr and gen 
SELECT DISTINCT
ci.cst_gndr,
ca.gen,
CASE WHEN ci.cst_gndr != 'n\a' THEN ci.cst_gndr ---- CRM is the Master for gender Info 
	 ELSE COALESCE(ca.gen,'n\a')
END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key=la.cid
ORDER BY 1,2

-- ====================================================================
-- Checking 'gold.product_key'

----Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'

--- Foreign Key Integrity (Dimensions)
select* from gold.fact_sales f
LEFT JOIN  gold.dim_customers c
ON c.customer_key = f.customer_key

LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL



