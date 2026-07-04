/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
===============================================================================
*/


EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @layer_start_time DATETIME, @layer_end_time DATETIME;
	
	SET @layer_start_time=GETDATE()
	BEGIN TRY
		PRINT'====================================================';
		PRINT'Loading the Bronze Layer';
		PRINT'====================================================';

		PRINT'-----------------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'-----------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.crm_cust_info ';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT'Inserting the Data into : bronze.crm_cust_info ';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
		/*SELECT * FROM bronze.crm_cust_info;
		SELECT COUNT(*) FROM bronze.crm_cust_info;
		*/

		--------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT'Inserting the Data into : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
		/*SELECT * FROM bronze.crm_sales_details;
		SELECT COUNT(*) FROM bronze.crm_sales_details;
		*/

		---------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT'Inserting the Data into : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
		/*SELECT * FROM bronze.crm_prd_info;
		SELECT COUNT(*) FROM bronze.crm_prd_info;
		*/



		-------------------------------------------------------------------------------
		PRINT'-----------------------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT'-----------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT'Inserting the Data into : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
		/*SELECT * FROM bronze.erp_cust_az12;
		SELECT COUNT(*) FROM bronze.erp_cust_az12;
		*/

		--------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT'Inserting the Data into : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
		/*SELECT * FROM bronze.erp_loc_a101;
		SELECT COUNT(*) FROM bronze.erp_loc_a101;
		*/
		----------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT'Truncating the Table : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT'Inserting the Data into : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\DBMS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'Load Duration : ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT'------------------------------------------'
	  /*SELECT * FROM bronze.erp_px_cat_g1v2;
		SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
	  */
	  SET @layer_end_time= GETDATE();
	  PRINT'Loading Duration of Complete BRONZE LAYER : ' + CAST(DATEDIFF(second,@layer_start_time, @layer_end_time) AS NVARCHAR) + 'seconds';
	  PRINT'------------------------------------------'
  END TRY
  
  BEGIN CATCH 
	PRINT'==========================================';
	PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT'Error Message' + ERROR_MESSAGE();
	PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT'==========================================';
  END CATCH
END
