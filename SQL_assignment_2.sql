-- concept questions:
-- 1, The result set is a set of data, it could be empty or not, returned by a select statement, or a stored procedure, that is saved in RAM or displayed on the screen.
-- 2, Union removes duplicate data, Union all does not. Using Union, the records from the first column will be sorted ascendingly. Union cannot be used in recursive, but Union all can.
-- 3, Union, Union all, Intersect and except
-- 4, Union combines result set of two or more select statement. JOIN combines data from many tables based on matched conditions between them. 
-- 5, INNER JOIN return the records that have matching values in both tables. FULL JOIN returns all records rows from left table and right table, if the join condition is not met, it will return null.
-- 6, OUTER JOIN includes left join, right join and full join. LEFT JOIN returns all records from the left table, and the matched records from right table, if there is matched value, it will return null. 
-- 7, Create the Cartesian product of two tables and ignore any filter criterial or any condition
-- 8, WHERE applies to individual rows, HAVING applies only to groups as a whole and only filter aggregation fileds. WHERE goes before aggregations, HAVING filters after the aggregtions. 
-- WHERE can be used with SELECT, UPDATE and DELETE statment, but HAVING can only be used in SELECT statment.
-- 9, yes, GROUP BY can apply to multiple columns. The data in these columns will conbine to unique combination.



--question 1
SELECT COUNT(*) 
FROM Production.Product

--question 2
SELECT COUNT(*) AS CountedProducts 
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--question 3
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CountedProducts 
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--question 4
SELECT COUNT(*) AS CountedProducts 
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--question 5
SELECT SUM(Quantity)
FROM Production.ProductInventory

--question 6
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--question 7
SELECT P2.Shelf,P1.ProductID,P1.TheSum 
FROM (SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100) P1 INNER JOIN Production.ProductInventory P2
ON P1.ProductID=P2.ProductID
WHERE P2.LocationID = 40

--question 8
SELECT AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

--question 9
SELECT ProductID, Shelf, AVG(Quantity)
FROM Production.ProductInventory
GROUP BY ProductID,Shelf
ORDER BY ProductID

--question 10
SELECT ProductID, Shelf, AVG(Quantity)
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID,Shelf
ORDER BY ProductID

--question 11
SELECT Color, Class, COUNT(Color) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--question 12
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c FULL JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode

--question 13
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c FULL JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')

--question 14
SELECT DISTINCT p.ProductName
FROM Products AS p JOIN [Order Details] AS o ON p.ProductID=o.ProductID JOIN Orders AS r ON o.OrderID=r.OrderID 
WHERE DATEDIFF(YEAR,r.OrderDate,GETDATE())<25

--question 15
SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) AS TheCount
FROM Orders o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY TheCount DESC

--question 16
SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) AS TheCount
FROM Orders o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND DATEDIFF(YEAR,o.OrderDate,GETDATE())<25
GROUP BY o.ShipPostalCode
ORDER BY TheCount DESC

SELECT TOP 5 ShipPostalCode, COUNT(ShipPostalCode) AS TheCount
FROM (SELECT ShipPostalCode
FROM Orders o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND DATEDIFF(YEAR,o.OrderDate,GETDATE())<25) as a
GROUP BY ShipPostalCode
ORDER BY TheCount DESC

--question 17
SELECT ShipCity, COUNT(ShipCity) AS TheCount
FROM(SELECT DISTINCT CustomerID, ShipCity
FROM Orders) AS a
GROUP BY ShipCity

--question 18
SELECT ShipCity, COUNT(ShipCity) AS TheCount
FROM(SELECT DISTINCT CustomerID, ShipCity
FROM Orders) AS a
GROUP BY ShipCity
HAVING COUNT(ShipCity) > 2

--question 19
SELECT ShipName, OrderDate
FROM Orders
WHERE OrderDate>'1/1/98'

--question 20
SELECT ShipName, MAX(OrderDate)
FROM Orders
GROUP BY ShipName

--question 21
SELECT o.ShipName, COUNT(o.ShipName) AS TheCount
FROM Orders AS o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
GROUP BY o.ShipName
ORDER BY o.ShipName

--question 22
SELECT o.CustomerID, COUNT(o.CustomerID) AS TheCount
FROM Orders AS o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
GROUP BY o.CustomerID
HAVING COUNT(o.CustomerID)>100
ORDER BY o.CustomerID

--question 23
SELECT su.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Suppliers AS su JOIN Products AS p ON su.SupplierID=p.SupplierID
JOIN [Order Details] AS od ON p.ProductID = od.ProductID
JOIN Orders AS o ON od.OrderID=o.OrderID
JOIN Shippers AS sh ON o.ShipVia=sh.ShipperID
ORDER BY su.CompanyName

--question 24
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Orders AS o JOIN [Order Details] AS d ON o.OrderID=d.OrderID
JOIN Products AS p ON d.ProductID=p.ProductID
ORDER BY o.OrderDate

--question 25
SELECT e1.LastName +' '+ e1.FirstName AS Employee1, e2.LastName +' '+ e2.FirstName AS Employee2, e1.Title
FROM Employees AS e1 JOIN Employees AS e2 ON e1.Title=e2.Title
WHERE e1.LastName!=e2.LastName AND e1.LastName<e2.LastName

--question 26
SELECT Manager, COUNT(Manager) AS TheCount
FROM(SELECT e1.LastName +' '+ e1.FirstName AS Manager
FROM Employees AS e1 JOIN Employees AS e2 ON e1.EmployeeID=e2.ReportsTo) as a
GROUP BY Manager
HAVING COUNT(Manager)>2

--question 27
SELECT City, CompanyName, ContactName, 'Customer' AS Type
FROM Customers
UNION ALL
SELECT City, CompanyName, ContactName, 'Supplier' AS Type
FROM Suppliers


