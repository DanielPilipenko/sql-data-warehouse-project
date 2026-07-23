/*
===============================================================================
Layer:        Silver
File:         01_ddl_silver_blueprint.sql
Description:  Creates the cleaned and standardized tables of the silver layer.
              Unlike bronze, all columns use proper data types (INT, DATE,
              DECIMAL) instead of flexible NVARCHAR(MAX).
              Each table gets a 'dwh_create_date' column to track when the
              record was loaded into the warehouse.
Author:       Daniel Pilipenko
===============================================================================
*/

USE DataWarehouse;
GO

-- Create the silver schema if it does not exist yet
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    [cst_id]             INT,
    [cst_key]            NVARCHAR(50),
    [cst_firstname]      NVARCHAR(50),
    [cst_lastname]       NVARCHAR(50),
    [cst_marital_status] NVARCHAR(50),
    [cst_gndr]           NVARCHAR(50),
    [cst_create_date]    DATE,
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    [prd_id]             INT,
    [cat_id]             NVARCHAR(50),  -- Derived from prd_key during the silver load (join key to erp_px_cat_g1v2)
    [prd_key]            NVARCHAR(50),
    [prd_nm]             NVARCHAR(50),
    [prd_cost]           DECIMAL(15,2), -- Monetary value with decimal places
    [prd_line]           NVARCHAR(50),
    [prd_start_dt]       DATE,
    [prd_end_dt]         DATE,
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    [sls_ord_num]        NVARCHAR(50),
    [sls_prd_key]        NVARCHAR(50),
    [sls_cust_id]        INT,
    [sls_order_dt]       DATE,          -- Bronze stores integer dates (e.g. 20101229); converted to DATE in the load
    [sls_ship_dt]        DATE,
    [sls_due_dt]         DATE,
    [sls_sales]          DECIMAL(15,2),
    [sls_quantity]       INT,
    [sls_price]          DECIMAL(15,2),
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    [CID]                NVARCHAR(50),
    [BDATE]              DATE,
    [GEN]                NVARCHAR(50),
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    [CID]                NVARCHAR(50),
    [CNTRY]              NVARCHAR(50),
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    [ID]                 NVARCHAR(50),
    [CAT]                NVARCHAR(50),
    [SUBCAT]             NVARCHAR(50),
    [MAINTENANCE]        NVARCHAR(50),
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO
