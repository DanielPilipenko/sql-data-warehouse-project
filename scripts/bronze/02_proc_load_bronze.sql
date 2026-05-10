/*
===============================================================================
Layer:        Bronze (Bronze)
File:         02_proc_load_bronze
Description:  This stored procedure loads data into our 'bronze' schema from external CSV files
              which are stored in folders. 
              Following actions are going to be performed:
                    - Truncate the bronze table before loading data
                    - Use 'BULK INSERT' command to load data from CSV files
Author:       Daniel Pilipenko
===============================================================================
*/


USE DataWarehouse;
GO 


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    
    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '====================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '====================================================';

        PRINT '----------------------------------------------------';
        PRINT 'Loading CRM Tables'
        PRINT '----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Info: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Info: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_crm\prd_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Info: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_crm\sales_details.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';

        PRINT '----------------------------------------------------';
        PRINT 'Loading ERP Layer';
        PRINT '----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_CUST_AZ12';
        TRUNCATE TABLE bronze.erp_CUST_AZ12;
        PRINT '>> Inserting Data Info: bronze.erp_CUST_AZ12';
        BULK INSERT bronze.erp_CUST_AZ12
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_erp\CUST_AZ12.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_LOC_A101';
        TRUNCATE TABLE bronze.erp_LOC_A101;
        PRINT '>> Inserting Data Info: bronze.erp_LOC_A101';
        BULK INSERT bronze.erp_LOC_A101
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_erp\LOC_A101.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';
      
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
        PRINT '>> Inserting Data Info: bronze.erp_PX_CAT_G1V2';
        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'C:\Users\Zakuti\Documents\Projekte\DWH\DP_SQL_DATA_WAREHOUSE_PROJECT\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ----------------';

        SET @batch_end_time = GETDATE();
        PRINT '=====================================';
        PRINT 'Loading Bronze Layer is completed';
        PRINT '    - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
    END TRY

    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
GO


EXEC bronze.load_bronze;