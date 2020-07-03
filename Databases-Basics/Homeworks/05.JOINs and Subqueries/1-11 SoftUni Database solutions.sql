USE SoftUni2

/*---01---*/
SELECT TOP(5) EmployeeID,JobTitle,a.AddressId, a.AddressText FROM Employees AS e
JOIN Addresses AS a ON a.AddressID=e.AddressID
ORDER BY AddressID ASC

/*---02---*/
SELECT TOP(50) e.FirstName,e.LastName,t.[Name],a.AddressText FROM Employees AS e
JOIN Addresses AS a ON e.AddressID=a.AddressID
JOIN Towns AS t ON a.TownID=t.TownID
ORDER BY FirstName,LastName

/*---03---*/
SELECT e.EmployeeID,e.FirstName,e.LastName,d.[Name] 
FROM Employees AS e
JOIN Departments AS d 
ON e.DepartmentID=d.DepartmentID
WHERE d.[Name]='Sales'
ORDER BY e.EmployeeID

/*---04---*/
SELECT TOP(5) e.EmployeeID,e.FirstName,e.Salary,d.[Name]
FROM Employees AS e
JOIN Departments AS d 
ON e.DepartmentID=d.DepartmentID
WHERE e.Salary>15000
ORDER BY d.DepartmentID ASC

/*---05---*/
SELECT TOP(3) e.EmployeeID,e.FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
ON e.EmployeeID=ep.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY EmployeeID ASC

/*---06---*/
SELECT e.FirstName,e.LastName,e.HireDate,d.[Name]
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID=d.DepartmentID
WHERE e.HireDate>'1999-01-01' AND d.[Name] IN ('Sales','Finance')
ORDER BY e.HireDate

/*---07---*/
SELECT TOP(5) e.EmployeeID,e.FirstName,p.[Name]
FROM Employees AS e
JOIN EmployeesProjects AS ep
ON e.EmployeeID=ep.EmployeeID
JOIN Projects AS p
ON ep.ProjectID=p.ProjectID
WHERE p.StartDate>'2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

/*---08---*/
SELECT e.EmployeeID,e.FirstName,
CASE 
    WHEN YEAR(p.StartDate) >= 2005 THEN NULL
ELSE p.[Name]
END AS [ProjectName] 
FROM Employees AS e
JOIN EmployeesProjects AS ep
ON e.EmployeeID=ep.EmployeeID
JOIN Projects AS p
ON ep.ProjectID=p.ProjectID
WHERE e.EmployeeID=24

/*---09---*/
SELECT e.EmployeeID,e.FirstName,e.ManagerID,
e2.FirstName AS [ManagerName]
FROM Employees AS e
JOIN Employees AS e2
ON e2.EmployeeID=e.ManagerID
WHERE e.ManagerID IN (3,7)
ORDER BY EmployeeID ASC

/*---10---*/
SELECT TOP(50) e.EmployeeID,(e.FirstName+ ' ' + e.LastName) AS [EmployeeName],
(e2.FirstName+' ' +e2.LastName) AS [ManagerName] ,d.[Name] AS [DepartmentName]
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID=d.DepartmentID
JOIN Employees AS e2
ON e.ManagerID=e2.EmployeeID
ORDER BY e.EmployeeID

/*---11---*/
SELECT MIN([Average Salary]) 
FROM  
(SELECT AVG(Salary) AS [Average Salary]
FROM Employees
GROUP BY DepartmentId) AS [Average Salary Query]






