--  top 5 staff members based on the number of rentals
CREATE VIEW Top5StaffCreateRentalView AS
SELECT TOP (5)
    s.[staffId],
    s.[firstName],
    s.[lastName],
    COUNT(r.[rentalId]) AS RentalCount
FROM [sakila].[dbo].[Staff] s
INNER JOIN [sakila].[dbo].[Rental] r ON s.[staffId] = r.[staffId]
GROUP BY s.[staffId], s.[firstName], s.[lastName]
ORDER BY RentalCount DESC;

--- the number of staff per store
CREATE VIEW StaffPerStoreView AS
SELECT
    [storeId],
    COUNT([staffId]) AS staff_count
FROM
    [sakila].[dbo].[Staff]
GROUP BY
    [storeId];

	--view that shows the number of rentals per
	CREATE VIEW RentalPerStaffView AS
SELECT
    [staffId],
    COUNT(*) AS rental_count
FROM
    [sakila].[dbo].[Rental]
GROUP BY
    [staffId]





