--1.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Yang
AS
SELECT ProductID, SUM(Quantity) as QunatityOrder 
FROM [Order Details]
group by ProductID
GO
--2.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_Yang
@id INT,
@quantities INT OUT
AS
BEGIN
    SELECT @quantities = SUM(Quantity)
    FROM [Order Details] WHERE ProductID = @id GROUP BY ProductID
END
BEGIN
DECLARE @qo INT
EXEC sp_product_order_quantity_Yang 1, @qo out
PRINT @qo
END

GO
--3.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_Yang
@pname VARCHAR(20),
@city VARCHAR(20) OUT,
@quantities INT OUT
AS
BEGIN
    SELECT TOP 5 @city = o.ShipCity, @quantities = SUM(od.Quantity)
    FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON od.OrderID = o.OrderID
    WHERE p.ProductName = @pname
    GROUP BY o.ShipCity
END
BEGIN
DECLARE @ct VARCHAR(20), @qt INT
EXEC sp_product_order_city_Yang Chai, @ct out, @qt
PRINT @ct
END

GO
--4.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_Yang(
    Id INT,
    Name VARCHAR(20),
    City INT FOREIGN KEY REFERENCES city_Yang (Id) 
);
INSERT INTO people_Yang VALUES(1, 'Aaron Rodgers', 2), (2, 'Russell Wilson', 1), (3, 'Jody Nelson', 2)
GO
CREATE TABLE city_Yang(
    Id INT PRIMARY KEY,
    City VARCHAR(20)
);
INSERT INTO city_Yang VALUES(1, 'Seattle'), (2, 'Green Bay')

GO
UPDATE city_Yang
SET City = 'Madison'
WHERE City = 'Seattle'

GO
CREATE VIEW Packers_Yang
AS
SELECT * FROM people_Yang WHERE City = 2

GO
--5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_Yang
AS
BEGIN
CREATE TABLE #birthday_employees_Yang(
    BirthDate DATE
)
DECLARE @Feb DATE = SELECT * FROM Employees WHERE MONTH(BirthDate) = 2
BEGIN
INSERT INTO #birthday_employees_Yang(BirthDate) VALUES(@Feb)
END

GO
--6.How do you make sure two tables have the same data?
Use Checksum TABLE and compare the result 