-- top 10 Customer Buy
CREATE VIEW Top10CustomerBuyView AS
SELECT TOP (10)
    c.[customerId],
    c.[firstName],
    c.[lastName],
    COUNT(p.[paymentId]) AS purchase_count
FROM [sakila].[dbo].[Customer] c
INNER JOIN [sakila].[dbo].[Payment] p ON c.[customerId] = p.[customerId]
GROUP BY c.[customerId], c.[firstName], c.[lastName]
ORDER BY purchase_count DESC;

--Customer Details
CREATE VIEW CustomerDetailsView AS
SELECT Customer.customerId, Customer.firstName, Customer.lastName,
Customer.active, Address.address, Address.phone, City.cityName,
Country.country, Customer.createDate
FROM Address
INNER JOIN City ON Address.cityId = City.cityId 
INNER JOIN Country ON City.countryId = Country.countryId
INNER JOIN Customer ON Address.addressId = Customer.addressId

-- CustomerPaymentSummaryView
CREATE VIEW CustomerPaymentSummaryView AS
SELECT 
    customerId,
    COUNT(paymentid) AS total_payments,
    SUM(amount) AS total_amount_paid
FROM Payment
GROUP BY customerId

-- CustomerRentalView
CREATE VIEW CustomerRentalView AS
SELECT 
    c.customerId,
    c.firstName,
    c.lastName,
    COUNT(r.rentalId) AS total_rentals,
    SUM(p.amount) AS total_payments
FROM customer c
LEFT JOIN rental r ON c.customerId = r.customerId
LEFT JOIN payment p ON c.customerId = p.customerId
GROUP BY c.customerId, c.firstName, c.lastName;

--- 
CREATE PROCEDURE GetCustomerById
    @CustomerId INT
AS
BEGIN
    SELECT * FROM customer WHERE customerid = @CustomerId;
END;


----
CREATE PROCEDURE GetCustomerRentalsByCategory
    @CustomerId INT,
    @CategoryName VARCHAR(50)
AS
BEGIN
    SELECT film.title, rental.returnDate, rental.returnDate
    FROM rental
    JOIN inventory ON rental.inventoryId = inventory.inventoryId
    JOIN film ON inventory.filmId = film.filmId
    JOIN filmCategory ON film.filmId = filmCategory.filmId
    JOIN category ON filmCategory.categoryId = category.categoryId
    WHERE rental.customerId = @CustomerId
    AND category.name = @CategoryName;
END;