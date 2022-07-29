--with solution
--1. Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the
--following.
--   Country                        Province
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode

--SELECT c.Name AS Country, s.Name AS Province  
--FROM Person.CountryRegion c  JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode;


--2. Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables and list the countries filter them by Germany and Canada.
--Join them and produce a result set similar to the following.
--    Country                        Province
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
WHERE pc.Name IN ('Germany', 'Canada')

--SELECT c.Name AS Country, s.Name AS Province  
--FROM Person.CountryRegion c  JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode 
--WHERE c.Name NOT IN ('Germany', 'Canada');


--Using Northwind Database: (Use aliases for all the Joins)
--3. List all Products that has been sold at least once in last 25 years.
SELECT p.ProductName, o.OrderDate, COUNT(o.OrderID) as NUmberOfOrder
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997-01-01'
GROUP BY p.ProductName, o.OrderDate
HAVING COUNT(o.OrderID) >= 1

--SELECT DISTINCT p.ProductID, p.ProductName 
--FROM Orders o JOIN [Order Details] od ON o.OrderID =  od.OrderID JOIN  Products p ON od.ProductID = p.ProductID 
--WHERE DATEDIFF(year, o.OrderDate, GETDATE())< 25;

--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, COUNT(o.OrderID) as NUmberOfOrder
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1997-01-01'
GROUP BY o.ShipPostalCode

--SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) as qty 
--FROM  Orders o JOIN [Order Details] od ON o.OrderID =  od.OrderID 
--WHERE o.ShipPostalCode IS NOT NULL  AND DATEDIFF(year, o.OrderDate, GETDATE())< 25 
--GROUP BY ShipPostalCode 
--ORDER BY qty DESC;


--5. List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) as NumberOfCustomers
FROM dbo.Customers
GROUP BY City

--select City, count(customerID) as NumOfCustomer 
--from customers 
--group by City

--6. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) as NumberOfCustomers
FROM dbo.Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

--select City, count(customerID) as NumOfCustomer 
--from customers 
--group by City 
--having count(customerID)>2


--7. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(od.Quantity) 
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName

--7. SELECT c.CustomerID, c.CompanyName, c.ContactName,  SUM(od.Quantity) AS QTY 
--FROM  Customers c  LEFT JOIN  Orders o  ON c.CustomerID = o.CustomerID LEFT JOIN  [Order Details] od ON o.OrderID = od.OrderID 
--GROUP BY c.CustomerID, c.CompanyName, c.ContactName ORDER BY QTY;


--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.ProductID) as NumberOfProduct
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID)  > 100

--SELECT c.CustomerID, SUM(od.Quantity) AS QTY 
--FROM  Customers c  LEFT JOIN  Orders o  ON c.CustomerID = o.CustomerID LEFT JOIN  [Order Details] od ON o.OrderID = od.OrderID 
--GROUP BY c.CustomerID 
--HAVING SUM(od.Quantity) > 100 
--ORDER BY QTY


--9. List all of the possible ways that suppliers can ship their products. Display the results as below

--    Supplier Company Name                Shipping Company Name

--    ---------------------------------            ----------------------------------
SELECT su.CompanyName, sh.CompanyName 
FROM Suppliers su CROSS JOIN Shippers sh 
Order By 2, 1

--SELECT sup.CompanyName, ship.CompanyName 
--FROM Suppliers sup CROSS JOIN Shippers ship 
--Order By 2, 1


--10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Products p ON od.ProductID = p.ProductID

--SELECT o.OrderDate, p.ProductName 
--FROM  Orders o LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID INNER JOIN Products p ON od.ProductID = p.ProductID 
--GROUP BY o.OrderDate, p.ProductName 
--ORDER BY o.OrderDate;


--11. Displays pairs of employees who have the same job title.
SELECT DISTINCT e1.FirstName, e2.FirstName
FROM Employees e1, Employees e2
WHERE e1.Title IN (SELECT e2.Title
FROM dbo.Employees e2)

--(1) SELECT Title, LastName + ' ' + FirstName AS Name  
--FROM Employees 
--ORDER BY Title;

--(2) SELECT e1.Title, e1.LastName + ' ' + e1.FirstName AS Name1, e2.LastName + ' ' + e2.FirstName AS Name2  
--FROM Employees e1 JOIN  Employees e2 ON e1.Title = e2.Title  
--WHERE e1.FirstName = e2.FirstName OR e1.LastName = e2.LastName 
--ORDER BY Title


--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName, COUNT(e.ReportsTo)
FROM Employees e JOIN Employees m ON e.EmployeeID = m.EmployeeID
GROUP BY m.FirstName
HAVING COUNT(e.ReportsTo) > 2

--SELECT T1.EmployeeId, T1.LastName, T1.FirstName,T2.ReportsTo, COUNT(T2.ReportsTo) AS Subordinate   
--FROM Employees T1 JOIN Employees T2 ON T1.EmployeeId = T2.ReportsTo 
--WHERE T2.ReportsTo IS NOT NULL 
--GROUP BY T1.EmployeeId, T1.LastName, T1.FirstName,T2.ReportsTo 
--HAVING COUNT(T2.ReportsTo) > 2



--13. Display the customers and suppliers by city. The results should have the following columns
--City
--Name
--Contact Name,
--Type (Customer or Supplier)
--All scenarios are based on Database NORTHWIND.
SELECT c.City, c.ContactName
FROM Suppliers su JOIN Products p ON su.SupplierID = p.SupplierID JOIN [Order Details] od ON p.ProductID = od.ProductID 
     JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON o.CustomerID = c.CustomerID

--SELECT c.City, c.CompanyName, c.ContactName, 'Customer' as Type 
--FROM Customers c 
--UNION 
--SELECT s.City, s.CompanyName, s.ContactName, 'Supplier' as Type 
--FROM Suppliers s;


--14. List all cities that have both Employees and Customers.
SELECT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE c.City = e.City 

--select distinct city 
--from Customers 
--where city in (select city from Employees)


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

---select distinct city  
--from Customers  
--where City not in (select distinct city from employees where city is not null)

--b.    
-- Do
--not use sub-query
SELECT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID JOIN Employees e ON o.EmployeeID = e.EmployeeID 
WHERE c.City != e.City

--select distinct city 
--from Customers   
--except  
--select distinct city 
--from Employees


--16. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, od.Quantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID

---select ProductID,SUM(Quantity) as QunatityOrdered 
--from [order details] 
--group by ProductID


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

--a. select city 
--from Customers 
--except 
--select city 
--from customers 
--group by city 
--having COUNT(*)=1 
--union  
--select city 
--from customers 
--group by city 
--having COUNT(*)=0


--b. 
-- Use
--no union
SELECT City, COUNT(CustomerID)
FROM Customers 
GROUP BY City
HAVING COUNT(CustomerID) >= 2

--b select city 
--from customers 
--group by city 
--having COUNT(*)>=2



--18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(od.ProductID)
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) >= 2

--select distinct city 
--from orders o join [order details] od on o.orderid=od.orderid join customers c on c.customerid=o.CustomerID 
--group by city 
--having COUNT(*)>=2


--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 ProductName, od.Quantity, c.City
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
ORDER BY  od.Quantity DESC

--select top 5 ProductID,AVG(UnitPrice) as AvgPrice,
--(select top 1 City 
--from Customers c join Orders o on o.CustomerID=c.CustomerID join [Order Details] od2 on od2.OrderID=o.OrderID 
--where od2.ProductID=od1.ProductID 
--group by city 
--order by SUM(Quantity) desc) as City 
--from [Order Details] od1 
--group by ProductID  
--order by sum(Quantity) desc

--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered
--from. (tip: join  sub-query)
SELECT e.City, od.Quantity, (SELECT COUNT(OrderID) FROM Orders)
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.City, od.Quantity
ORDER BY od.Quantity DESC

--select (select top 1 City 
--        from Orders o join [Order Details] od on o.OrderID=od.OrderID join Employees e on e.EmployeeID = o.EmployeeID 
--        group by e.EmployeeID,e.City 
--        order by COUNT(*) desc) as MostOrderedCity, 
--        (select top 1 City 
--         from Orders o join [Order Details] od on o.OrderID=od.OrderID join Employees e on e.EmployeeID = o.EmployeeID 
--         group by e.EmployeeID,e.City order by sum(Quantity) desc) as MostQunatitySoldCity


--21. How do you remove the duplicates record of a table?
Using DISTINCT keyword
--use Row_Number() with parition by then delete the rows where rowNumber > 1