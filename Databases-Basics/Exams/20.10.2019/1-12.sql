CREATE DATABASE [Service]

USE [Service]

/*---01---*/
CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] NVARCHAR(50),
	Birthdate DATETIME2,
	Age INT
	CHECK(AGE BETWEEN 14 AND 110),
	[Email] VARCHAR(50) NOT NULL
)

CREATE TABLE [Status]
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Label] VARCHAR(30) NOT NULL
)

CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME2,
	Age INT
	CHECK(AGE BETWEEN 18 AND 110),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE Reports
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	StatusId INT FOREIGN KEY REFERENCES [Status](Id) NOT NULL,
	OpenDate DATETIME2 NOT NULL,
	CloseDate DATETIME2,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

/*---02---*/
INSERT INTO Employees(FirstName,LastName,Birthdate,DepartmentId)
VALUES
('Marlo','O''Malley','1958-09-21',1),
('Niki','Stanaghan','1969-11-26',4),
('Ayrton','Senna','1960-03-21',9),
('Ronnie','Peterson','1944-02-14',9),
('Giovanna','Amati','1959-07-20',5)

INSERT INTO Reports(CategoryId,StatusId,OpenDate,CloseDate,[Description],UserId,EmployeeId)
VALUES
(1,1,'2017-04-13',NULL,'Stuck Road on Str.133',6,2),
(6,3,'2015-09-05','2015-12-06','Charity trail running',3,5),
(14,2,'2015-09-07',NULL,'Falling bricks on Str.58',5,2),
(4,3,'2017-07-03','2017-07-06','Cut off streetlight on Str.11',1,1)

/*---03---*/
UPDATE Reports
SET CloseDate=GETDATE()
WHERE CloseDate IS NULL

/*---04---*/
DELETE Reports 
WHERE StatusId=4

/*---05---*/
SELECT [Description],FORMAT(OpenDate,'dd-MM-yyyy') AS OpenDate
FROM Reports
WHERE EmployeeId IS NULL
ORDER BY FORMAT(OpenDate,'yyyy-MM-dd') ASC,[Description] ASC

/*---06---*/
SELECT r.[Description],c.[Name] FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId=c.Id
WHERE CategoryId IS NOT NULL
ORDER BY [Description] ASC, c.[Name] ASC

/*---07---*/
SELECT TOP(5) c.[Name],COUNT(*) AS [ReportsNumber]
FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId=c.Id
GROUP BY CategoryId,[Name]
ORDER BY [ReportsNumber] DESC,[Name] ASC

/*---08---*/
SELECT Username,c.[Name] AS [CategoryName]
FROM Users AS u
JOIN Reports AS r
ON r.UserId=u.Id
JOIN Categories AS c
ON r.CategoryId=c.Id
WHERE DAY(OpenDate)=DAY(u.Birthdate) AND MONTH(OpenDate)=MONTH(u.Birthdate)
ORDER BY u.Username ASC, c.[Name] ASC

/*---09---*/
SELECT e.FirstName + ' ' + e.LastName AS [FullName],COUNT(EmployeeId) AS [UsersCount] 
FROM Reports AS r
RIGHT JOIN Employees AS e
ON r.EmployeeId=e.Id
GROUP BY EmployeeId,FirstName,LastName
ORDER BY [UsersCount] DESC,FullName ASC

/*---10---*/
SELECT CASE
		WHEN e.FirstName + ' ' + e.LastName IS NULL THEN 'None'
		ELSE e.FirstName + ' ' + e.LastName
		END AS [Employee],
		CASE
		WHEN d.[Name] IS NULL THEN 'None'
		ELSE d.[Name]
		END AS [Department],
		CASE 
		WHEN c.[Name] IS NULL THEN 'None'
		ELSE c.[Name]
		END AS [Category],
		CASE 
		WHEN r.[Description] IS NULL THEN 'None'
		ELSE r.[Description]
		END AS [Description],
		CASE 
		WHEN FORMAT(OpenDate,'dd.MM.yyyy') IS NULL THEN 'None'
		ELSE FORMAT(OpenDate,'dd.MM.yyyy')
		END AS [OpenDate],
		CASE 
		WHEN s.[Label] IS NULL THEN 'None'
		ELSE s.[Label]
		END AS [Status],
		CASE
			WHEN u.[Name] IS NULL THEN 'None'
			ELSE u.[Name]
			END AS [User]
		
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentId=d.Id
RIGHT JOIN Reports AS r
ON r.EmployeeId= e.Id
JOIN Categories AS c
ON c.Id=r.CategoryId
JOIN [Status] AS s
ON s.Id=r.StatusId
JOIN Users AS u
ON u.Id=r.UserId
ORDER BY FirstName DESC, 
			LastName DESC,
			Department ASC,
			Category ASC,
			[Description] ASC,
			OpenDate ASC,
			[Status] ASC,
			[User] ASC

/*---11---*/
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
		IF(@StartDate IS NULL) RETURN 0;
		IF(@EndDate IS NULL) RETURN 0;
		ELSE
		BEGIN 
				RETURN CAST(DATEDIFF(HOUR, @StartDate, @EndDate) AS INT)
		END
		RETURN 0;
END

--SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
--   FROM Reports

/*---12---*/
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT) 
AS
IF((SELECT DepartmentId FROM Employees
		WHERE Id=@EmployeeId)=(SELECT DepartmentId FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId=c.Id
WHERE r.Id=@ReportId))
BEGIN
UPDATE Reports
SET EmployeeId=@EmployeeId
WHERE (SELECT DepartmentId FROM Employees
		WHERE Id=@EmployeeId)=(SELECT DepartmentId FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId=c.Id
WHERE r.Id=@ReportId)
END
ELSE 
RAISERROR('Employee doesn''t belong to the appropriate department!',16,1)


