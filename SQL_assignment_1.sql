--question 1
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
--question 2
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product WHERE ListPrice = 0
--question 3 
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product WHERE Color IS NULL
--question 4
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product WHERE not Color IS NULL
--question 5
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product 
WHERE not Color IS NULL AND ListPrice > 0
--question 6
SELECT Name + ' ' + Color AS "Name And Color"
FROM Production.Product 
WHERE not Color IS NULL
--question 7
SELECT 'NAME: '+Name+' -- COLOR: '+Color AS "Name And Color"
FROM Production.Product
WHERE NOT Color IS NULL
--question 8
SELECT ProductID, Name
FROM Production.Product 
WHERE ProductID BETWEEN 400 AND 500
--question 9
SELECT ProductID, Name, Color
FROM Production.Product 
WHERE Color IN ('Black', 'Blue')
--question 10
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
Where Name LIKE 'S%'
--question 11
SELECT Name, ListPrice
FROM Production.Product
Where Name LIKE 'S%'
ORDER BY Name
--question 12
SELECT Name, ListPrice
FROM Production.Product
Where Name LIKE 'A%' OR Name LIKE 'S%'
ORDER BY Name
--question 13
SELECT *
FROM Production.Product
Where Name LIKE 'SPO%' AND Name NOT LIKE '___K%'
ORDER BY Name
--question 14
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC
--question 15
SELECT DISTINCT ProductSubcategoryID, Color
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL and Color IS NOT NULL
ORDER BY ProductSubcategoryID