--Top 10 Last update
CREATE VIEW Top10LastUpdatePaymentsView AS
SELECT TOP (10) [paymentId], [rentalId], [customerId], [staffId], [amount], [paymentDate], [lastUpdate]
FROM [sakila].[dbo].[Payment]
ORDER BY [lastUpdate] DESC;

-- the last payment 
CREATE VIEW LastPaymentView AS
SELECT TOP (1) [paymentId], [rentalId], [customerId], [staffId], [amount], [paymentDate], [lastUpdate]
FROM [sakila].[dbo].[Payment]
ORDER BY [paymentDate] DESC;

-- get total payment by Year
CREATE VIEW TotalPaymentByMonthView AS
SELECT
    YEAR(paymentDate) AS PaymentYear,
    SUM(amount) AS TotalPayment
FROM
    [sakila].[dbo].[Payment]
GROUP BY
    YEAR(paymentDate)

--- all data relation on paymnet
CREATE VIEW PaymentHistoryView AS
SELECT 
    p.paymentId,
    c.customerId,
    CONCAT(c.firstName, ' ', c.lastName) AS customer_name,
    p.amount,
    p.paymentDate,
    r.rentalId,
    r.rentalDate
FROM Payment p
JOIN Rental r ON p.rentalId = r.rentalId
JOIN Customer c ON p.customerId = c.customerId;

-- Total payment Summery Per Month
CREATE VIEW MonthlyPaymentSummaryView AS
SELECT 
    YEAR(paymentDate) AS payment_year,
    MONTH(paymentDate) AS payment_month,
    COUNT(paymentDate) AS total_payments,
    SUM(amount) AS total_amount_paid
FROM payment
GROUP BY YEAR(paymentDate), MONTH(paymentDate)
