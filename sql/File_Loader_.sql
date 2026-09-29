CREATE DATABASE vm_3
GO
USE vm_3
GO

CREATE TABLE customer_revenue (
	customer_id INT,
	months DATE,
	revenue DECIMAL (10,2));

CREATE TABLE customer_industries (
	customer_id INT,
	industry NVARCHAR(MAX),
	sector NVARCHAR(MAX))

CREATE TABLE customer_data (
	customer_id INT,
	customer_name NVARCHAR(MAX),
	customer_country NVARCHAR(MAX),
	customer_continent NVARCHAR(MAX));
GO

DECLARE @user_name SYSNAME = N'JIGNESHHHHH';
DECLARE @schema_name SYSNAME = N'dbo';

-- list of files and target tables
DECLARE @files TABLE (id INT IDENTITY(1,1), file_name NVARCHAR(4000), table_name SYSNAME);
INSERT INTO @files (file_name, table_name) VALUES
 (N'revenue_data_.csv', N'customer_revenue'),
 (N'customers_industry_sector.csv', N'customer_industries'),
 (N'historical_customers.csv', N'customer_data');

DECLARE @minId INT, @maxId INT, @i INT;
SELECT @minId = MIN(id), @maxId = MAX(id) FROM @files;
SET @i = ISNULL(@minId, 0);

WHILE @i > 0 AND @i <= @maxId
BEGIN
    DECLARE @file_name NVARCHAR(4000), @table_name SYSNAME;
    SELECT @file_name = file_name, @table_name = table_name FROM @files WHERE id = @i;

    -- build server-side file path (the SQL Server service account must access this path)
    DECLARE @file_source NVARCHAR(4000) = N'C:\Users\' + @user_name + N'\Downloads\' + @file_name;

    -- validate target table exists
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE s.name = @schema_name AND t.name = @table_name
    )
    BEGIN
        RAISERROR('Target table %s.%s not found. Skipping %s', 16, 1, @schema_name, @table_name, @file_name);
        SET @i = @i + 1;
        CONTINUE;
    END

    -- escape single quotes in file path
    DECLARE @file_esc NVARCHAR(4000) = REPLACE(@file_source, N'''', N'''''');

    -- build safe dynamic SQL
    DECLARE @sql NVARCHAR(MAX) = N'BULK INSERT ' + QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name)
        + N' FROM ''' + @file_esc + N''' WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';

    PRINT @sql; -- inspect before executing

    BEGIN TRY
        EXEC sp_executesql @sql;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;

    SET @i = @i + 1;
END
GO