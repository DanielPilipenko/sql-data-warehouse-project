/*
=============================================================
Create Database and Schemas
=============================================================
Project: Data Warehouse (Saes Analytics)
Analogy:
       Think of this as building a Restaurant.
       We are establishing the building, the utilities and
       the different work zones (loading dock, Kitchen, dining).
*/

USE master;
GO

/* STEP 1: THE RECONNAISSANCE (Checking if the building exists)
   We look into the 'sys.databases' table, which is like the city's official 
   building register.
*/
IF EXISTS (
    /* 'SELECT 1' is a trick: We don't need actual data, 
       we just want to know IF a row with this name exists. 
       If yes, it returns '1' (True). 
    */
    SELECT 1 
    FROM sys.databases 
    WHERE name = 'DataWarehouse'
)
BEGIN
    /* STEP 1.1: THE BOUNCER MOVE (Clearing the restaurant)
       You cannot bulldoze a building while guests are inside.
       
       - ALTER DATABASE: We change the 'rules' for this database.
       - SET SINGLE_USER: We lock the doors. Only ONE person (you) can stay.
       - WITH ROLLBACK IMMEDIATE: This kicks everyone out INSTANTLY. 
         If someone was currently writing data, their work is cancelled (rolled back) 
         so we can proceed without waiting.
    */
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    /* STEP 1.2: THE DEMOLITION (Bulldozing)
       Now that the building is empty and locked, we delete it entirely.
    */
    DROP DATABASE DataWarehouse;
END;
GO

/* =============================================================
CREATE DATABASE AND WORK ZONES (SCHEMAS)
=============================================================
*/
-- STEP 2: CONSTRUCT THE BUILDING (Create Database)
/* Analogy: We are building the physical restaurant. 
   'COLLATE' is like setting the "House Rules" for how we speak and sort things.
*/
CREATE DATABASE DataWarehouse
/* 'COLLATE Latin1_General_CI_AS' explained:
   - Latin1_General: The alphabet/character set (supports German Umlauts like Ä, Ö, Ü).
   - CI (Case Insensitive): 'Apple' is the same as 'apple'.
   - AS (Accent Sensitive): 'a' is NOT the same as 'á'.
   This ensures our "Menu" (Data) is sorted correctly.
*/
COLLATE Latin1_General_CI_AS;
GO

-- STEP 3: OPEN THE FRON DOOR
-- We tell SQL Server: "All following commands happen INSIDE this building."
USE DataWarehouse;
GO

-- STEP 4: DEFINE WORK ZONES (create schemas)
/* Analogy: A professional kitchen needs separate areas to avoid chaos.
   In SQL, "Schemas" are these areas.
*/

-- BRONZE: The Loading Dock (Raw Data)
-- Where ingredients arrive directly from the truck.
-- It's okay if they are still dirty or unsorted. We just want them inside.
CREATE SCHEMA bronze;
GO

-- SILVER: The Prep Kitchen (Cleaned & Standardized)
-- This is where we wash, peel, and cut the ingredients.
-- Everything here is put into standard containers (Data Types).
CREATE SCHEMA silver;
GO

-- GOLD: The Dining Room (Business Logic & KPI's)
-- This is where the final, gourmet meals are served to the guests (Stakeholders)
-- High-quality, polished and ready for the "menu" (Reports).
CREATE SCHEMA gold;
GO

-- STEP 5: OPTIMIZATION (The Logbook)
/* By deafult, SQL Server records every tiny movement in the "Log Files".
   Analogy: Like a flight recorder (Black Box)

   'SET RECOVEY SIMPLE' tells the server:
   "We are a local restaurant, not a global bank. Don't waste disk space recording every single step. If we crash, we'll just reload the truck."
   This keeps the hard drive from filling up with useless logs.
*/

ALTER DATABASE DataWarehouse SET RECOVERY SIMPLE;
GO