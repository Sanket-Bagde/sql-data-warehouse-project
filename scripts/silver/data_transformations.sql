/*
Data Transformations:
  This SQL file contains various data transformation queries for data validation, standardization, and consistency checks across multiple datasets.
*/

-----------------------------------
-- Checking 'silver.crm_cust_info'
-----------------------------------
---Check for unwanted spaces
--Expectation_ No Results
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr!= TRIM(cst_gndr)

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

---------------------------------
-- Checking 'silver.crm_prd_info'
---------------------------------
--Check For NULLs or duplicates in Primary Key
--Expectation: No Result
SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 or prd_id IS NULL

---Check for NULLs or Negative Numbers 
---Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Data Standardization and Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

---Check for Invalid Date Orders
Select *
from bronze.crm_prd_info
Where prd_end_dt < prd_start_dt

---------------------------------------
--- Checking 'silver.crm_sales_details'
---------------------------------------
---Check for invalid dates

select 
NULLIF(sls_ship_dt,0) sls_ship_dt

From bronze.crm_sales_details
WHere sls_ship_dt <=0 
OR len(sls_ship_dt) !=8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

---To check that the order date should be less than the shipping date

select
*
From bronze.crm_sales_details
where sls_order_dt > sls_ship_dt 
OR sls_order_dt >sls_due_dt

----To check data consistency : Between sales, Quantity , Price
----	Sales = Quantity * Price
----	Values must not be NULL, zero, or negative
SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity *ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=0
		THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price

------------------------------------
--- Checking 'silver.erp_cust_az12'
------------------------------------
--- To identify out of range dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate< '1924-01-01' OR bdate> GETDATE()

--- Data standardization and consistency
----- To check distinct genders
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('M' , 'MALE') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'Female'
	 ELSE 'n/a'
END AS gen
FROM silver.erp_cust_az12

select * from silver.erp_cust_az12

---------------------------------------
--- Checking 'silver.erp_loc_a101'
---------------------------------------
----  Data Consistency and Standardization
SELECT Distinct 
cntry AS old_cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
FROM silver.erp_loc_a101
ORDER BY cntry
  
-------------------------------------
--- Checking 'silver.erp_px_cat_g1v2'
-------------------------------------
----Check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

----Data Consistency and Standardization

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2
