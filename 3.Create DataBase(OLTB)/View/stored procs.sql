USE sakila;

GO
-- Getting the frequency of any entity in any table
CREATE OR ALTER PROC count_entity @column VARCHAR(20), @table VARCHAR(20), @topN INT = 100000
AS
BEGIN
	DECLARE @SqlQuery NVARCHAR(MAX);
	SET @SqlQuery = 'SELECT TOP(' + CONVERT(NVARCHAR(50), @topN) + ')' + QUOTENAME(@column) + ' AS ' + QUOTENAME(@column) + ',' +
					'COUNT(' + QUOTENAME(@column) + ') AS [Count of ' + @column + ']' +
        ' FROM ' +@table +
        ' GROUP BY ' + QUOTENAME(@column) +
        ' ORDER BY 2 DESC;';

	EXEC sp_executesql @SqlQuery;
END

GO

EXEC count_entity customerid, rental, 10
EXEC count_entity customerid, rental

EXEC count_entity filmid, inventory

GO
--Who are the top 10 customers by rental frequency?
CREATE OR ALTER PROC topNcustmersByRentalFrequency @topN INT
AS
BEGIN
	DECLARE @SqlQuery NVARCHAR(MAX);
	SET @SqlQuery = 'SELECT TOP(' + CONVERT(NVARCHAR(50), @topN) + ')' +
	'c.firstName+'' ''+c.lastName AS full_name, COUNT(r.customerId) AS rental_frequency
	FROM Rental r, Customer c
	WHERE c.customerId = r.customerId
	GROUP BY firstName, lastName
	ORDER BY rental_frequency DESC'

	EXEC sp_executesql @SqlQuery;
END

go
EXEC topNcustmersByRentalFrequency 10

GO

--What is the average rental duration per customer?
CREATE OR ALTER PROC avg_rental_duration @customer_id INT = NULL
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);
    
    -- Build the dynamic SQL statement
    SET @SqlQuery = 'SELECT * FROM dbo.vRentalPeriod WHERE 1=1';

    -- Add condition for customer_id if it's provided
    IF @customer_id IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND customer_id = @ParamCustomerID';
    END

    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlQuery, N'@ParamCustomerID INT', @customer_id;
END

GO
EXEC avg_rental_duration 17
EXEC avg_rental_duration

GO
--How many new customers did we acquire each month?
CREATE OR ALTER PROC customers_per_month 
    @month INT = NULL, 
    @year INT = NULL
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    SET @SqlQuery = 'SELECT COUNT(customerid) AS number_of_customers, 
                            MONTH(paymentDate) AS month_num, 
                            YEAR(paymentDate) AS year_num 
                    FROM Payment
                    WHERE 1 = 1'; -- Always true condition to start the WHERE clause

    -- Add filters based on the parameters
    IF @month IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND MONTH(paymentDate) = ' + CONVERT(NVARCHAR(50), @month);
    END

    IF @year IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND YEAR(paymentDate) = ' + CONVERT(NVARCHAR(50), @year);
    END

    -- Grouping and ordering
    SET @SqlQuery = @SqlQuery + ' GROUP BY MONTH(paymentDate), YEAR(paymentDate) 
                                  ORDER BY year_num, month_num';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlQuery;
END

GO
EXEC customers_per_month 3,2014
EXEC customers_per_month 3
EXEC customers_per_month

-- When do customers pay the rent?
GO
CREATE OR ALTER PROC calc_diff_payment_rental @payment_id INT = NULL
AS
BEGIN
	DECLARE @SqlQuery NVARCHAR(MAX);

    SET @SqlQuery = 'SELECT DATEDIFF(DAY, rentalDate, paymentDate) days_after_rental, DATEDIFF(DAY, returnDate, paymentDate) days_after_return
                    FROM vRentalPayment
                    WHERE 1 = 1'
	IF @payment_id IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND paymentId = ' + CONVERT(NVARCHAR(50), @payment_id);
    END

	EXEC sp_executesql @SqlQuery;
END

EXEC calc_diff_payment_rental --We conclude that the customer pays the rent in the return date
EXEC calc_diff_payment_rental 40250