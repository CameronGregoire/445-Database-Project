--THIS FILE MAKES OUR QUERIES
USE LibraryDB
GO

-- SCENARIO 1a: Find book by name
SELECT 
	BOOK.BookID,
	BOOK.BookName as 'Book Name',
	BOOK.PageCount as 'Page Count',
	BOOK.AuthorName as 'Author Name',
	PUBLISHER.PublisherName as 'Publisher Name'
FROM BOOK
INNER JOIN PUBLISHER ON PUBLISHER.PublisherID = BOOK.BookID
WHERE BookName = 'The Great Gatsby';

-- SCENARIO 1b: Find books by author and genre
SELECT 
	BOOK.BookID, 
	BOOK.BookName as 'Book Name', 
	BOOK.AuthorName as 'Author Name', 
	GENRE.GenreName as 'Genre Name'
FROM 
	BOOK
INNER JOIN AVAILABILITY ON BOOK.BookID = AVAILABILITY.BookID
INNER JOIN LIBRARY_SECTION ON AVAILABILITY.SectionID = LIBRARY_SECTION.SectionID
INNER JOIN GENRE ON LIBRARY_SECTION.GenreName = GENRE.GenreName
WHERE 
	BOOK.AuthorName = 'Dick Henry' AND 
	GENRE.GenreName = 'Romance';

-- SCENARIO 1c: Find books by rating
SELECT 
	BOOK.BookID, 
	BOOK.BookName as 'Book Name', 
	AVG(REVIEW.Rating) AS 'Average Rating'
FROM 
	BOOK
INNER JOIN REVIEW ON BOOK.BookID = REVIEW.BookID
GROUP BY 
	BOOK.BookID, 
	BOOK.BookName
HAVING 
	AVG(REVIEW.Rating) >= 3;

-- SCENARIO 1d: Find the books by a certain publisher
SELECT 
	BOOK.BookID,
	BOOK.BookName as 'Book Name',
	BOOK.PageCount as 'Page Count',
	BOOK.AuthorName as 'Author Name',
	PUBLISHER.PublisherName as 'Publisher Name'
FROM 
	BOOK
INNER JOIN PUBLISHER ON BOOK.PublisherID = PUBLISHER.PublisherID
WHERE 
	PUBLISHER.PublisherName = 'Bethesda Softworks';

-- SCENARIO 2a: Check availability of a certain book at a specified library ID.
SELECT
	AVAILABILITY.LibraryID,
	BOOK.BookName as 'Book Name',
	AVAILABILITY.Quantity
FROM
	BOOK
INNER JOIN AVAILABILITY ON BOOK.BookID = AVAILABILITY.BookID
WHERE
	BOOK.BookName = 'The Adventures of Huckleberry Finn' AND
	AVAILABILITY.LibraryID = 3 AND
	AVAILABILITY.Quantity > 0;

-- SCENARIO 2b: Check when and where the next shipment for a book is. If no shipment is found, then there are no upcoming shipments for the specified book.
SELECT
	SHIPMENT.ShipDate as 'Ship Date',
	SHIPMENT.LibraryID,
	SHIPMENT.Quantity
FROM
	SHIPMENT
INNER JOIN BOOK ON SHIPMENT.Description = BOOK.BookName
WHERE
	BOOK.BookName = 'The Art of Procrastination'
	

-- SCENARIO 3: Users should be able to purchase a membership with this library franchise.
DECLARE @NewMembershipID int;

BEGIN TRANSACTION;

-- Create the new membership
INSERT INTO MEMBERSHIP(StartDate, EndDate)
VALUES('2023-06-01', '2023-07-01');

-- Get the ID of the newly inserted membership
SET @NewMembershipID = SCOPE_IDENTITY();

-- Update the existing customer to use the new membership ID
UPDATE CUSTOMER
SET MembershipID = @NewMembershipID
WHERE CustomerID = 1; -- Replace with your actual customer ID

COMMIT;	-- At this point you can check the customer in CUSTOMER table with customerID 1 and see if their membershipID has changed

-- SCENARIO 4: Customers should be able to check for upcoming events at different library locations in the franchise.
SELECT
	EVENT.DateOfEvent as 'Event Date',
	EVENT.EventName as 'Event Name',
	EVENT.EventDescription as 'Description'
FROM
	EVENT
WHERE
	EVENT.LibraryID = 1

	--SCENARIO 5: Employees should be able to track incoming shipments to the library.
SELECT
    SHIPMENT.LibraryID,
	SHIPMENT.ShipmentID,
    SHIPMENT.ShipDate,
    BOOK.BookName AS 'Book Name',
    SHIPMENT.Quantity
FROM
	SHIPMENT
INNER JOIN BOOK ON SHIPMENT.Description = BOOK.BookName
WHERE
    SHIPMENT.LibraryID = 3

--Scenario 6: Users should be able to register within the library system. 
DECLARE @NewCustomerID int;

BEGIN TRANSACTION;

INSERT INTO CUSTOMER VALUES('Josh Smith', 47, 1, 98101, 'hosmith@example.com', '2229876543', null);

SET @NewCustomerID = SCOPE_IDENTITY();
COMMIT;
GO

--Scenario 7 & 8: The system should be able to keep track of inventory changes when books are sold/checkedout or vise versa.
CREATE PROCEDURE SellBook 
    @BookID INT,
    @Quantity INT
AS
BEGIN
    UPDATE AVAILABILITY 
    SET Quantity = Quantity - 1
    WHERE BookID = 10;
    
    -- To prevent negative values in Quantity field
    UPDATE AVAILABILITY 
    SET Quantity = 0
    WHERE Quantity < 0;
END
GO -- We can call this procedure using EXEC SellBook @BookID, @Quantity

--Analytical Query 1a:  Find a book by a specific author and/or at a specified library. 
--Author and Rating Completed by Scenario 1b and 1c
SELECT
    AVAILABILITY.LibraryID,
    BOOK.BookName,
    AVAILABILITY.Quantity
FROM
    AVAILABILITY
INNER JOIN
    BOOK ON AVAILABILITY.BookID = BOOK.BookID
WHERE
    BOOK.BookName = 'The Art of Procrastination';

--Analytical Query 2: Completed in Scenario 2b

--Analytical Query 3: Find out when next billing cycle for membership is for a customer by when membership ends. 
SELECT
    CUSTOMER.CustomerID,
    CUSTOMER.CustomerName,
    MEMBERSHIP.EndDate AS 'Next Billing Date'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
WHERE
    CUSTOMER.CustomerName = 'Jane Smith';

--Analytical Query 4a: Find out how many customers are currently paying got membership in a specified Zip.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
--INNER JOIN
   -- MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
WHERE
	CUSTOMER.MembershipID IS NOT NULL AND
    CUSTOMER.ZipCode = '98101';

--Analytical Query 4b: Find out how many customers are currently paying got membership in a specified City.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
INNER JOIN
    CITY ON CUSTOMER.CityID = CITY.CityID
WHERE
    CITY.CityName = 'Puyallup';

--Analytical Query 4c: Find out how many customers are currently paying got membership in a specified State.
SELECT
    COUNT(*) AS 'Total Customers'
FROM
    CUSTOMER
INNER JOIN
    MEMBERSHIP ON CUSTOMER.MembershipID = MEMBERSHIP.MembershipID
INNER JOIN
    STATE ON CUSTOMER.StateID = STATE.StateID
WHERE
    State.StateName = 'Washington';

--Analytical Query 5a: Find the Phone Number of a customer. 
SELECT
    Phone
FROM
    CUSTOMER
WHERE
    CustomerName = 'Jane Smith';

--Analytical Query 5b: Find the Email of a customer. 
SELECT
    Email
FROM
    CUSTOMER
WHERE
    CustomerName = 'Jane Smith';

