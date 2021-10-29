--concept question
--1, I prefer JOIN because the SQL Server optimized the JOIN operation.
--2, common table expression, cte can call itself again and again, so we usually use it for recursive. 
--3, The table variable is a spectial type of the local variable that helps to store data temporarily. The scope is local variables, and stored in tempDB
--4,
--5,
--6,

--question 1
SELECT DISTINCT e.City
FROM Employees e JOIN Customers c ON e.City=c.City

--question 2
--a
SELECT DISTINCT City 
FROM Customers
WHERE City NOT IN
(SELECT City FROM Employees)
--b
SELECT DISTINCT o.City
FROM Customers o LEFT JOIN Employees e ON o.City=e.City
WHERE e.City IS NULL

--question 3
SELECT p.ProductName, a.TheCount
FROM (SELECT ProductID, SUM(Quantity) as TheCount
FROM [Order Details]
GROUP BY ProductID) AS a JOIN Products p ON a.ProductID = p.ProductID

--question 4
SELECT c.City, SUM(a.TheCount) AS Ordersquatity
FROM(SELECT o.CustomerID, SUM(d.Quantity) AS TheCount
FROM Orders o JOIN [Order Details] d ON o.OrderID=d.OrderID
GROUP BY o.CustomerID) AS a JOIN Customers c ON a.CustomerID=c.CustomerID
GROUP BY c.City

--question 5
SELECT City, COUNT(CustomerID) AS Customernumber
FROM(SELECT DISTINCT City, CustomerID 
FROM Customers) AS a
GROUP BY City
HAVING COUNT(CustomerID)>1

--question 6
SELECT b.City, COUNT(b.ProductID)
FROM (SELECT DISTINCT c.City,a.ProductID
FROM (SELECT o.CustomerID, d.ProductID
FROM Orders o JOIN [Order Details] d ON o.OrderID=d.OrderID) AS a JOIN Customers c ON a.CustomerID=c.CustomerID) AS b
GROUP BY b.City
HAVING COUNT(b.ProductID)>1

--question 7
WITH AA AS
(SELECT DISTINCT c.CustomerID,c.City,o.ShipCity
FROM Customers c JOIN Orders o ON c.CustomerID=o.CustomerID)
SELECT a1.CustomerID
FROM AA a1 JOIN AA a2 ON a1.CustomerID=a2.CustomerID AND a1.ShipCity!=a2.City

--question 8
WITH Subquery AS(SELECT d.ProductID, d.UnitPrice, d.Quantity, o.ShipCity
FROM [Order Details] d JOIN Orders o ON d.OrderID=o.OrderID),
sub2 as (SELECT TOP 5 s.ProductID,AVG(s.UnitPrice) AS average,SUM(s.Quantity) as total
FROM Subquery s
GROUP BY s.ProductID
ORDER BY total DESC),
sub3 as (SELECT s.ProductID,SUM(s.Quantity) AS total,s.ShipCity 
FROM Subquery s
GROUP BY s.ProductID,s.ShipCity),
sub4 as (SELECT sub3.ProductID,MAX(sub3.total) AS maximum
FROM sub3
GROUP BY sub3.ProductID),
sub5 as (SELECT sub3.ProductID, sub3.total, sub3.ShipCity
FROM sub3 JOIN sub4 ON sub3.total = sub4.maximum and sub3.ProductID=sub4.ProductID)

SELECT p.ProductName, sub2.average, sub5.ShipCity,sub5.total
FROM sub2 JOIN sub5 ON sub2.ProductID=sub5.ProductID JOIN Products p ON sub2.ProductID = p.ProductID

--question 9
SELECT City
FROM Employees
WHERE City NOT IN(SELECT DISTINCT ShipCity
FROM Orders)

SELECT e.City
FROM Employees e LEFT JOIN Orders o ON e.City=o.ShipCity
WHERE o.ShipCity IS NULL

--question 10
SELECT e.City,COUNT(o.OrderID) AS orders
FROM Employees e JOIN Orders o ON e.EmployeeID=o.EmployeeID
GROUP BY e.City
ORDER BY orders DESC

SELECT e.City,SUM(d.Quantity) AS total
FROM Employees e JOIN Orders o ON e.EmployeeID=o.EmployeeID JOIN [Order Details] d ON o.OrderID=d.OrderID
GROUP BY e.City
ORDER BY total DESC
--NOT EXIST 

--question 11
--Use RANK function and PARTITION BY clause to rank the rows having same data with unique ranking number, then delete the rows with ranking larger than 1


--Employee (empid integer, mgrid integer, deptid integer, salary money) Dept (deptid integer, deptname varchar(20))

--question 12
SELECT 
FROM Employee e1 LEFT JOIN Employee e2 ON e1.empid = e2.mgrid
WHERE e2.mgrid IS NULL

--question 13
SELECT deptname, TheCount
FROM
(
 SELECT deptname, TheCount, DENSE_RANK() OVER (ORDER BY TheCount DESC) AS rk
 FROM 
   (SELECT  d.deptname, COUNT(e.empid) AS TheCount
    FROM Employee e JOIN Dept d ON e.deptid=d.deptid
    GROUP BY d.deptname) a 
)b
WHERE rk = 1
ORDER BY deptname


--question 14
SELECT deptname,empid,salary
FROM
    (SELECT  d.deptname, e.empid,e.salary, RANK() OVER(ORDER BY e.salary DESC) AS rk
    FROM Employee e JOIN Dept d ON e.deptid=d.deptid)
WHERE rk<4
ORDER BY deptname, salary DESC