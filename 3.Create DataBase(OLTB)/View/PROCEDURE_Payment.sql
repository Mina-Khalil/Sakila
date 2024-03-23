CREATE PROCEDURE Select_one_Payments
    @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN
    SELECT
        [paymentId],
        [rentalId],
        [customerId],
        [staffId],
        [amount],
        [paymentDate],
        [lastUpdate]
    FROM
        [sakila].[dbo].[Payment]
    WHERE
        [paymentDate] BETWEEN @startDate AND @endDate;
END

EXEC Select_one_Payments @startDate = '2000-01-01', @endDate = '2010-03-01';

