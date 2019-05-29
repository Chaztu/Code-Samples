--
-- Part 2 Q1
--

SELECT r.bookTitle, Recieved - Sold Stock
FROM 

(SELECT bookTitle, SUM(quantity) Sold
FROM (SELECT book.bookCode, bookTitle, COALESCE(quantity, 0) Quantity, COALESCE(transactionTypeID, 0) TransactionTypeID FROM book LEFT JOIN inventory ON book.bookCode = inventory.bookCode)
WHERE transactionTypeID = 1 OR transactionTypeID = 0
GROUP BY bookTitle
ORDER BY bookCode) s,
 
(SELECT bookTitle, SUM(quantity) Recieved
FROM (SELECT book.bookCode, bookTitle, COALESCE(quantity, 0) Quantity, COALESCE(transactionTypeID, 0) TransactionTypeID FROM book LEFT JOIN inventory ON book.bookCode = inventory.bookCode)
WHERE transactionTypeID = 2 OR transactionTypeID = 0
GROUP BY bookTitle
ORDER BY bookCode) r
 
WHERE s.bookTitle = r.bookTitle;

--
-- Part 2 Q2
--

SELECT CASE WHEN roleID = 1 THEN 'Manager' END AS Type, 
	"$" || CAST (SUM(salary) as Integer) Salary, 
	round((SELECT SUM(salary) FROM StaffAssignment WHERE roleID = 1)/ (SELECT SUM(salary) FROM StaffAssignment) * 100, 2) || "%" Percentage
FROM StaffAssignment
WHERE roleID = 1

UNION

SELECT CASE WHEN roleID <> 1 THEN 'Non-Manager' END AS Type, 
	"$" || CAST (SUM(salary) as Integer) Salary, 
	round((SELECT SUM(salary) FROM StaffAssignment WHERE roleID <> 1)/ (SELECT SUM(salary) FROM StaffAssignment) * 100, 2) || "%" Percentage
FROM StaffAssignment
WHERE roleID <> 1;

--
-- Part 2 Q3
--

SELECT CASE
WHEN price >= minValue AND price <= maxValue THEN bookGrade END AS Grade,
 GROUP_CONCAT((bookTitle || " (" || Year || ")"), ", ") Books
FROM

(SELECT BookPrice.bookCode, price, substr(pubDate, 1, 4) Year
FROM BookPrice, Writing
WHERE BookPrice.bookCode = Writing.bookCode
GROUP BY BookPrice.bookCode
ORDER BY price) a, Book, BookGrade

WHERE a.bookCode = Book.BookCode
AND Grade NOT NULL
GROUP BY Grade
ORDER BY price;


--
-- Part 2 Q4
--

CREATE VIEW StaffStatus
AS
SELECT Staff, Status,
(CAST(Days / 365.25 AS int) || ' Year(s) ' || (CAST(Days / 30.44 AS int) % 12) || ' Month(s)') Duration
FROM

(SELECT staffFirstName Staff, 
CASE WHEN current_date > endDate THEN 'Inactive' ELSE 'Active' END AS Status,
CASE WHEN endDate IS NOT NULL AND endDate < current_date THEN julianday(endDate) - julianday(startDate)
ELSE julianday(current_date) - julianday(startDate) END AS Days
FROM Staff, StaffAssignment
WHERE Staff.staffCode = StaffAssignment.staffCode
ORDER BY Status ASC, Days DESC);

--
-- End of File
--