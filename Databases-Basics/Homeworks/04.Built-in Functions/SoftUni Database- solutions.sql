USE SoftUni2

/*---01---*/
SELECT FirstName,LastName FROM Employees
WHERE FirstName LIKE 'Sa%'

/*---02---*/
SELECT FirstName,LastName FROM Employees
WHERE LastName LIKE '%ei%'

/*---03---*/
SELECT FirstName FROM Employees
WHERE DepartmentID IN(3,10) AND Year(HireDate) BETWEEN 1995 AND 2005

/*---04---*/
SELECT FirstName,LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

/*---05---*/
SELECT [Name] FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name] ASC

/*---06---*/
SELECT TownId,[Name] FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name] ASC

/*---07---*/
SELECT TownId,[Name] FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name] ASC

/*---08---*/
GO
CREATE VIEW V_EmployeesHiredAfter2000
AS
(
	SELECT FirstName,LastName FROM Employees
	WHERE Year(HireDate) > 2000
)
GO

/*---09---*/
SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName) = 5

/*---10---*/
SELECT EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000 
ORDER BY Salary DESC

/*---11---*/
SELECT * FROM
(
SELECT EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000 
)
AS [Rank Table]
WHERE [Rank]=2
ORDER BY Salary DESC







