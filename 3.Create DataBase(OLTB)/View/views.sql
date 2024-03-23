USE sakila;

GO
CREATE OR ALTER VIEW vRentalPeriod(customer_id, full_name, rental_period)
AS
SELECT c.customerId, c.firstName + ' ' + c.lastName AS full_name, AVG(DATEDIFF(DAY, rentalDate, returnDate)) AS avg_rental_period FROM Rental r, Customer c
WHERE r.customerId = c.customerId
GROUP BY c.customerId, firstName, lastName

GO

SELECT * FROM vRentalPeriod
ORDER BY full_name

GO
CREATE OR ALTER VIEW vRentalPayment
AS
SELECT r.rentalId, r.customerId AS customer_rented, r.staffId AS staff_rented, r.rentalDate, r.returnDate,
p.paymentId, p.customerId AS customer_paid, p.staffId AS staff_paid_to, p.paymentDate
FROM Payment p, Rental r
WHERE p.rentalId = r.rentalId

GO
SELECT * FROM vRentalPayment