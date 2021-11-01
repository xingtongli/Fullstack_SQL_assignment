--concept
--1, virtual table that contains data from one or multiple tables. Simplify data manipulation, 
--enable you to create a backward compatible interface for a table when its schema changes, 
--to customize data, distributed queries can also be used to define views that use data from
--mutiple heterogeneous sources, good for combine similar structured data from different servers.

--2, Yes, all the update, insert and delete operation will be applied to the database.

--3, Prepared SQL query that we can save and reuse. Increase datebase security, faster execution, 
--Stored precedures help centralize your transact-SQL code in the data tier,
--Stored procedures can help reduce network traffic for larger ad hoc queries.
--Stored procedures encourage code reusability. --4, sp accept parameters, view does not accept parameters-- sp cannot be used as building block in a larger query, view can be used as building block in a larger query-- sp contains several statements, view only contain one single select query--5, usage: store procedure for DML, functions: for calculations
-- store procedure called by its name, functions must be called in selection statements
-- input: store procedure may or may not have input parameters. functions must have inputs
-- output: store procedure may or may not have outout, functios must have outputs
-- store procedure can call function, functions cannot call store procedure
--6, 
--7, No, SELECT statement is a list of conditions, it produce the result set with matches those conditions. 
-- sp is a set of instructions that change things in a very predictable way.

--8, Triggers are a special type of stored procedure that get executed (fired) when a specific event happens.
-- DML, DDL, LOGON

--9, trigger is a stored procedure that runs automatically when various events happen (eg update, insert, delete).
-- Stored procedures are a pieces of the code in written to do some specific task.
-- Tigger cannot take input as parameter, sp can.
-- trigger can execute automatically based on the events, sp can be invoked explicitly by the user.
-- trigger can not return values, sp can.


--question 1
CREATE VIEW view_product_order_li
AS
SELECT p.ProductID, p.ProductName, SUM(d.Quantity) AS total
FROM Products p JOIN [Order Details] d ON p.ProductID=d.ProductID
GROUP BY p.ProductID, p.ProductName

select * from view_product_order_li


--question 2
CREATE PROC sp_product_order_quantity_li
@id int,
@quantity int out
AS
BEGIN
SELECT @quantity = total 
FROM view_product_order_li
WHERE ProductID = @id
END

BEGIN
declare @en int
exec sp_product_order_quantity_li 23, @en out
print @en
END

--question 3
CREATE PROC sp_product_order_city_li
@en varchar(20)
AS
BEGIN
SELECT TOP 5 city, total
FROM (SELECT p.ProductName, o.ShipCity AS city, SUM(d.Quantity) AS total
FROM Products p JOIN [Order Details] d ON p.ProductID=d.ProductID JOIN Orders o ON d.OrderID=o.OrderID
GROUP BY p.ProductName,o.ShipCity) a
WHERE ProductName = @en
ORDER BY total DESC
END


exec sp_product_order_city_li Chai

--question 4
CREATE TABLE people_li
(Id int,
Name varchar(20),
City int)
INSERT INTO people_li VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_li VALUES(2, 'Russell Wilson', 1)
INSERT INTO people_li VALUES(3, 'Jody Nelson', 2)

CREATE TABLE city_li
(Id int,
City varchar(20))
INSERT INTO city_li VALUES(1,'Seattle')
INSERT INTO city_li VALUES(2,'Green Bay')

DELETE FROM city_li
WHERE City = 'Seattle'
INSERT INTO city_li VALUES(1,'Madison')

CREATE VIEW Packers_li
AS
SELECT p.Id, p.Name
FROM people_li p JOIN city_li c ON p.City=c.Id
WHERE c.City = 'Green Bay'
select * from Packers_li

DROP TABLE city_li
DROP TABLE people_li
DROP VIEW Packers_li

--question 5
CREATE PROC sp_birthday_employees_li
AS
BEGIN
SELECT LastName,FirstName,BirthDate
INTO Employee
FROM Employees
WHERE MONTH(BirthDate) = 2
END

EXEC sp_birthday_employees_li

SELECT * FROM Employee

DROP TABLE Employee

--question 6
--the result should have the same rows as table 1 or 2
SELECT * FROM table1
UNION
SELECT * FROM table2

--question 7
CREATE TABLE names(
[First Name] varchar(20),
[Last Name] varchar(20),
[Middle Name] varchar(20),)
INSERT INTO names VALUES('John','Green',null)
INSERT INTO names VALUES('Mike','White','M')

SELECT * FROM names

CREATE VIEW fullname
AS
SELECT [First Name] + ' ' + [Last Name]+ ' ' + ISNULL(Middlename,'') AS [Full Name]
FROM (
SELECT [First Name], [Last Name], [Middle Name] + '.' AS [Middlename]
FROM names ) a

SELECT * FROM fullname

--question 8
CREATE TABLE marks(
Student varchar(20),
Marks int,
Sex varchar(20))
INSERT INTO marks VALUES('Ci',70,'F')
INSERT INTO marks VALUES('Bob',80,'M')
INSERT INTO marks VALUES('Li',90,'F')
INSERT INTO marks VALUES('Mi',95,'M')

SELECT TOP 1 *
FROM marks
WHERE Sex = 'F'
ORDER BY Marks DESC

--question 9
SELECT *
FROM marks
ORDER BY Sex, Marks DESC
