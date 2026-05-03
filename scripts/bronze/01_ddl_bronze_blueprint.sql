/*
===============================================================================
Layer:        Bronze (Raw Data)
File:         01_ddl_bronze_blueprint.sql
Description:  This script builds the shelves. We use big shelves (NVARCHAR MAX) 
              so everything fits, even if the data is messy.
Author:       Daniel Pilipenko
===============================================================================
*/

USE DataWarehouse;
GO

/*
Create the storage area, if it is not there yet 
(Before we create a new "storage called bronze." we first check if one does exist)

CREATE must be one of the first commands to run properly. Yet we first check 
with an "IF" if it exist. There for we "hide" the CREATE inside an "envelope" 
(EXEC = execute). While the script is running, SQL won't mind if the "CREATE" 
is not on the first place. Incase there is already a bronze schema, 
SQL will skip everything between "BEGIN" and "END".
*/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

/*
-- Create tables (shelves) with flexible size. If they already exist,
drop them and create new ones.

"U" = "user-defined table", it will look for a real table and will ignore
a view or other type with the exact same name.

GETDATE() = gives the exact timestamp to know how up-to-date it is.
*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    [cst_id] NVARCHAR(MAX), [cst_key] NVARCHAR(MAX), [cst_firstname] NVARCHAR(MAX),
    [cst_lastname] NVARCHAR(MAX), [cst_marital_status] NVARCHAR(MAX), [cst_gndr] NVARCHAR(MAX),
    [cst_create_date] NVARCHAR(MAX)
);
GO

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    [prd_id] NVARCHAR(MAX), [prd_key] NVARCHAR(MAX), [prd_nm] NVARCHAR(MAX),
    [prd_cost] NVARCHAR(MAX), [prd_line] NVARCHAR(MAX), [prd_start_dt] NVARCHAR(MAX),
    [prd_end_dt] NVARCHAR(MAX)
);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    [sls_ord_num] NVARCHAR(MAX), [sls_prd_key] NVARCHAR(MAX), [sls_cust_id] NVARCHAR(MAX),
    [sls_order_dt] NVARCHAR(MAX), [sls_ship_dt] NVARCHAR(MAX), [sls_due_dt] NVARCHAR(MAX),
    [sls_sales] NVARCHAR(MAX), [sls_quantity] NVARCHAR(MAX), [sls_price] NVARCHAR(MAX),
    [extraction_date] DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    [CID] NVARCHAR(MAX), [BDATE] NVARCHAR(MAX), [GEN] NVARCHAR(MAX),
    [extraction_date] DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    [CID] NVARCHAR(MAX), [CNTRY] NVARCHAR(MAX),
    [extraction_date] DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    [ID] NVARCHAR(MAX), [CAT] NVARCHAR(MAX), [SUBCAT] NVARCHAR(MAX), [MAINTENANCE] NVARCHAR(MAX),
    [extraction_date] DATETIME DEFAULT GETDATE()
);
GO