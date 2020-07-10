USE SoftUni2

/*---13---*/
SELECT DepartmentID,SUM(Salary) FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

/*---14---*/
SELECT DepartmentID,MIN(Salary) FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate>'2000-01-01'
GROUP BY DepartmentID
ORDER BY DepartmentID

/*---15---*/
SELECT * INTO EmployeesWithHighSalaries
FROM Employees
WHERE Salary > 30000

DELETE FROM EmployeesWithHighSalaries
WHERE ManagerID=42

UPDATE EmployeesWithHighSalaries
SET Salary+=5000
WHERE DepartmentID=1

SELECT DepartmentID,AVG(Salary) AS [AverageSalary] FROM EmployeesWithHighSalaries
GROUP BY DepartmentID

/*---16---*/
SELECT DepartmentID,MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

/*---17---*/
SELECT COUNT(Salary) AS [Count] FROM Employees
WHERE ManagerID IS NULL

/*---18---*/
SELECT DepartmentID,r.Salary AS [ThirdHighestSalary] 
FROM (			
			SELECT DepartmentID,
			DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank],
			Salary FROM Employees GROUP BY DepartmentID,Salary) AS r
WHERE [Rank]=3

/*---19---*/
---First way
SELECT TOP(10) FirstName,LastName,e.DepartmentID 
FROM ( SELECT DepartmentID,AVG(Salary) AS [AverageSalary]
		FROM Employees
		GROUP BY DepartmentID) AS [GroupingQuery],Employees AS e
WHERE Salary > [AverageSalary] AND e.DepartmentID=[GroupingQuery].DepartmentID
ORDER BY DepartmentID

---Second way
SELECT TOP(10) e1.FirstName,e1.LastName,e1.DepartmentID 
FROM Employees as e1
WHERE e1.Salary > (
					SELECT AVG(Salary) AS [Average Salary]
					FROM Employees AS eAvgSalary
					WHERE eAvgSalary.DepartmentID=e1.DepartmentID
					GROUP BY DepartmentID
				  )
ORDER BY DepartmentID ASC






