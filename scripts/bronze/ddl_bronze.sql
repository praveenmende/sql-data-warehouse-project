/*
=============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
=============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        PRINT '=======================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '=======================================';

        PRINT '---------------------------------------';
        PRINT 'LOADING CRM LAYERS';
        PRINT '---------------------------------------';

        PRINT '>>INSERTING DATA INTO: Bronze.crm_cust_info';

        SET @START_TIME = GETDATE();

        BULK INSERT Bronze.crm_cust_info
        FROM 'C:\sqldata\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

        EXEC xp_fileexist 'C:\sqldata\cust_info.csv';

        PRINT '>>INSERTING DATA INTO: Bronze.crm_prd_info';

        SET @START_TIME = GETDATE();

        BULK INSERT Bronze.crm_prd_info
        FROM 'C:\sqldata\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

        EXEC xp_fileexist 'C:\sqldata\sales_details.csv';

        PRINT '>>INSERTING DATA INTO: Bronze.crm_sales_details';

        SET @START_TIME = GETDATE();

        BULK INSERT Bronze.crm_sales_details
        FROM 'C:\sqldata\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

        PRINT '---------------------------------------';
        PRINT 'LOADING ERP LAYERS';
        PRINT '---------------------------------------';

        PRINT '>>INSERTING DATA INTO: bronze.erp_CUST_AZ12';

        SET @START_TIME = GETDATE();

        BULK INSERT bronze.erp_CUST_AZ12
        FROM 'C:\sqldata\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

        PRINT '>>INSERTING DATA INTO: bronze.erp_LOC_A101';

        SET @START_TIME = GETDATE();

        BULK INSERT bronze.erp_LOC_A101
        FROM 'C:\sqldata\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

        PRINT '>>INSERTING DATA INTO: bronze.erp_PX_CAT_G1V2';

        SET @START_TIME = GETDATE();

        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'C:\sqldata\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        PRINT '>> Load Duration:'
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + 'seconds';

        PRINT '---------------------------------------------------';

    END TRY

    BEGIN CATCH

        PRINT '=============================================';
        PRINT 'ERROR OCCURED DURING LOADING THE BRONZE LAYER';
        PRINT 'ERROR MESSAGE:' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER:' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR LINE:' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==============================================';

    END CATCH

END;
GO

EXEC bronze.load_bronze;
