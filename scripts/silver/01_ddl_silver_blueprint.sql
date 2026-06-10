/*
===============================================================================
Layer:        Silver
File:         01_ddl_silver_blueprint.sql
Description:  Clean and standardized tables matching the load script perfectly
Author:       Daniel Pilipenko
===============================================================================
*/

USE DataWarehouse;
GO

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
    [cat_id]             NVARCHAR(50), -- 💡 NEU: Wurde vom Ladeskript benötigt!
    [prd_key]            NVARCHAR(50),
    [prd_nm]             NVARCHAR(50),
    [prd_cost]           DECIMAL(15,2), -- Für Preise nutzen wir Zahlen mit Nachkommastellen
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
    [sls_order_dt]       DATE,          -- 💡 KORREKTUR: DATE statt INT, da das Skript echte Daten liefert
    [sls_ship_dt]        DATE,          -- 💡 KORREKTUR: DATE statt INT
    [sls_due_dt]         DATE,          -- 💡 KORREKTUR: DATE statt INT
    [sls_sales]          DECIMAL(15,2), -- 💡 KORREKTUR: DECIMAL statt INT
    [sls_quantity]       INT,
    [sls_price]          DECIMAL(15,2), -- 💡 KORREKTUR: DECIMAL statt INT
    [dwh_create_date]    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    [CID]                NVARCHAR(50),  -- 💡 KORREKTUR: MAX entfernt
    [BDATE]              DATE,
    [GEN]                NVARCHAR(50),  -- 💡 KORREKTUR: MAX entfernt
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