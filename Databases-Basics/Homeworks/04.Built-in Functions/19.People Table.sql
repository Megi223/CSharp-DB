CREATE DATABASE PEOPLE2
USE PEOPLE2

CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(20) NOT NULL,
	Birthdate DATETIME NOT NULL
)

INSERT INTO People([Name],Birthdate)
VALUES
('Peter','2000-12-07 00:00:00.000'),
('Steven','2000-12-07 00:00:00.000'),
('Stephen','2000-12-07 00:00:00.000'),
('John','2000-12-07 00:00:00.000')

SELECT [Name], 
DATEDIFF(YEAR,Birthdate,GETDATE()) AS [Age in Years],
DATEDIFF(MONTH,Birthdate,GETDATE()) AS [Age in Months],
DATEDIFF(DAY,Birthdate,GETDATE()) AS [Age in Days],
DATEDIFF(MINUTE,Birthdate,GETDATE()) AS [Age in Minutes]
FROM People