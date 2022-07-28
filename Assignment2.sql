--1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the
--following.
--   Country                        Province
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode

--2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada.
--Join them and produce a result set similar to the following.
--    Country                        Province
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
WHERE pc.Name IN ('Germany', 'Canada')

--Using Northwind Database: (Use aliases for all the Joins)
--3. List all Products that has been sold at least once in last 25 years.
SELECT p.ProductName, o.OrderDate, COUNT(o.OrderID) as NUmberOfOrder
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997-01-01'
GROUP BY p.ProductName, o.OrderDate
HAVING COUNT(o.OrderID) >= 1

--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, COUNT(o.OrderID) as NUmberOfOrder
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997-01-01'
GROUP BY o.ShipPostalCode


--5. List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) as NumberOfCustomers
FROM dbo.Customers
GROUP BY City

--6. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) as NumberOfCustomers
FROM dbo.Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

--7. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(od.Quantity) 
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName

--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.ProductID) as NumberOfProduct
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID)  > 100

--9. List all of the possible ways that suppliers can ship their products. Display the results as below

--    Supplier Company Name                Shipping Company Name

--    ---------------------------------            ----------------------------------


--10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Products p ON od.ProductID = p.ProductID

--11. Displays pairs of employees who have the same job title.
SELECT DISTINCT e1.FirstName, e2.FirstName
FROM Employees e1, Employees e2
WHERE e1.Title IN (SELECT e2.Title
FROM dbo.Employees e2)

--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName, COUNT(e.ReportsTo)
FROM Employees e JOIN Employees m ON e.EmployeeID = m.EmployeeID
GROUP BY m.FirstName
HAVING COUNT(e.ReportsTo) > 2

SELECT * FROM Employees

--13. Display the customers and suppliers by city. The results should have the following columns
--City
--Name
--Contact Name,
--Type (Customer or Supplier)
--All scenarios are based on Database NORTHWIND.
SELECT c.City, c.ContactName
FROM Suppliers su JOIN Products p ON su.SupplierID = p.SupplierID JOIN [Order Details] od ON p.ProductID = od.ProductID 
     JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON o.CustomerID = c.CustomerID

--14. List all cities that have both Employees and Customers.
SELECT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE c.City = e.City 

--15. List all cities that have Customers but no Employee.
--a. 
-- Use
--sub-query
SELECT City
FROM Customers
WHERE City NOT IN(
    SELECT City
    FROM Employees
)

--b.    
-- Do
--not use sub-query
SELECT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID JOIN Employees e ON o.EmployeeID = e.EmployeeID 
WHERE c.City != e.City

--16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, od.Quantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID

--17. List all Customer Cities that have at least two customers.
--a. 
-- Use
--union
SELECT City, COUNT(CustomerID)
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) = 2
UNION
SELECT City, COUNT(CustomerID)
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

--b. 
-- Use
--no union
SELECT City, COUNT(CustomerID)
FROM Customers 
GROUP BY City
HAVING COUNT(CustomerID) >= 2

--18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(od.ProductID)
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) >= 2

--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 ProductName, od.Quantity, c.City
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
ORDER BY  od.Quantity DESC


--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered
--from. (tip: join  sub-query)
SELECT e.City, od.Quantity, (SELECT COUNT(OrderID) FROM Orders)
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.City, od.Quantity
ORDER BY od.Quantity DESC

--21. How do you remove the duplicates record of a table?
Using DISTINCT keyword