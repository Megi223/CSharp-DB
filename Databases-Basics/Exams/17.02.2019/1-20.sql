CREATE DATABASE School

USE School

/*---01---*/
CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	MiddleName NVARCHAR(25),
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL CHECK (Age BETWEEN 5 AND 100),
	[Address] NVARCHAR(50),
	Phone NCHAR(10)
)

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(20) NOT NULL,
	Lessons INT NOT NULL CHECK(Lessons>0)
)

CREATE TABLE StudentsSubjects
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL,
	Grade DECIMAL(3,2) NOT NULL CHECK(Grade BETWEEN 2 AND 6)
)

CREATE TABLE Exams
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Date] DATETIME2,
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	ExamId INT FOREIGN KEY REFERENCES Exams(Id) NOT NULL,
	Grade DECIMAL(3,2) NOT NULL CHECK(Grade BETWEEN 2 AND 6)
	PRIMARY KEY(StudentId,ExamId)
)

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	[Address] NVARCHAR(20) NOT NULL,
	Phone NCHAR(10),
	SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
)

CREATE TABLE StudentsTeachers
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL,
	TeacherId INT FOREIGN KEY REFERENCES Teachers(Id) NOT NULL,
	PRIMARY KEY(StudentId,TeacherId)
)

/*---02---*/
INSERT INTO Teachers(FirstName,LastName,[Address],Phone,SubjectId)
VALUES
('Ruthanne','Bamb','84948 Mesta Junction','3105500146',6),
('Gerrard','Lowin','370 Talisman Plaza','3324874824',2),
('Merrile','Lambdin','81 Dahle Plaza','4373065154',5),
('Bert','Ivie','2 Gateway Circle','4409584510',4)

INSERT INTO Subjects([Name],Lessons)
VALUES
('Geometry',12),
('Health',10),
('Drama',7),
('Sports',9)

/*---03---*/
UPDATE StudentsSubjects
SET Grade=6.00
WHERE (SubjectId=1 OR SubjectId=2) AND Grade>=5.50

/*---04---*/
DELETE FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id FROM Teachers WHERE Phone LIKE '%72%')
DELETE FROM Teachers
WHERE Phone LIKE '%72%'

/*---05---*/
SELECT FirstName,LastName,Age FROM Students
WHERE Age>=12
ORDER BY FirstName ASC,LastName ASC

/*---06---*/
SELECT CONCAT(FirstName,' ',MiddleName,' ',LastName) AS [Full Name],[Address] FROM Students
WHERE [Address] LIKE '%road%'
ORDER BY FirstName,LastName,[Address]

/*---07---*/
SELECT FirstName,[Address],Phone FROM Students
WHERE MiddleName IS NOT NULL AND Phone LIKE '42%'
ORDER BY FirstName

/*---08---*/
SELECT FirstName,LastName,COUNT(st.TeacherId) FROM Students AS s
LEFT JOIN StudentsTeachers AS st
ON s.Id=st.StudentId
GROUP BY st.StudentId,FirstName,LastName
ORDER BY LastName

/*---09---*/
SELECT FirstName + ' ' + LastName AS [FullName],
		s.[Name] + '-' + CAST(Lessons AS VARCHAR(5)) AS [Subjects],COUNT(StudentId) AS [Students]
FROM Teachers AS t
LEFT JOIN Subjects AS s
ON t.SubjectId=s.Id
JOIN StudentsTeachers AS st
ON st.TeacherId=t.Id
GROUP BY s.[Name],t.FirstName,t.LastName,Lessons
ORDER BY Students DESC,FullName ASC,Subjects ASC

/*---10---*/
SELECT FirstName + ' ' + LastName AS [Full Name] FROM Students AS s
LEFT JOIN StudentsExams AS se
ON s.Id=se.StudentId
WHERE se.StudentId IS NULL
ORDER BY [Full Name]

/*---11---*/
SELECT TOP(10) FirstName,LastName,COUNT(StudentId) AS [StudentsCount]
FROM Teachers AS t
JOIN StudentsTeachers AS st
ON t.Id=st.TeacherId
GROUP BY TeacherId,FirstName,LastName
ORDER BY [StudentsCount] DESC,FirstName,LastName

/*---12---*/
SELECT TOP(10) FirstName AS [First Name],
		LastName AS [Last Name],
		CAST(AVG(Grade) AS DECIMAL(3,2)) AS [Grade]
FROM Students AS s
JOIN StudentsExams AS se
ON s.Id=se.StudentId
GROUP BY se.StudentId,FirstName,LastName
ORDER BY Grade DESC,FirstName ASC,LastName ASC

/*---13---*/
---First way- using WHERE- clause
SELECT FirstName,LastName,Grade FROM (SELECT FirstName,LastName,ROW_NUMBER() OVER(PARTITION BY StudentId ORDER BY Grade DESC) AS [Rank],(ss.Grade) AS [Grade] FROM Students AS s
RIGHT JOIN StudentsSubjects AS ss
ON s.Id=ss.StudentId) AS [InnerQuery]
WHERE [Rank]=2
GROUP BY FirstName,LastName,Grade,[Rank]
ORDER BY FirstName,LastName

---Second way- using GROUP BY- clause
SELECT FirstName,LastName,Grade FROM (SELECT FirstName,LastName,ROW_NUMBER() OVER(PARTITION BY StudentId ORDER BY Grade DESC) AS [Rank],(ss.Grade) AS [Grade] FROM Students AS s
RIGHT JOIN StudentsSubjects AS ss
ON s.Id=ss.StudentId) AS [InnerQuery]
GROUP BY FirstName,LastName,Grade,[Rank]
HAVING [Rank]=2
ORDER BY FirstName,LastName

/*---14---*/
SELECT CONCAT(FirstName , ' ' ,MiddleName + ' ', LastName) AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsSubjects AS ss
ON s.Id=ss.StudentId
WHERE ss.StudentId IS NULL
GROUP BY ss.StudentId,FirstName,MiddleName,LastName
ORDER BY [Full Name]

/*---15---*/
SELECT [Teacher Full Name], SubjectName ,[Student Full Name], FORMAT(TopGrade, 'N2') AS Grade
  FROM (
SELECT [Teacher Full Name],SubjectName, [Student Full Name], AverageGrade  AS TopGrade,
	   ROW_NUMBER() OVER (PARTITION BY [Teacher Full Name] ORDER BY AverageGrade DESC) AS RowNumber
  FROM (
  SELECT t.FirstName + ' ' + t.LastName AS [Teacher Full Name],
  	   s.FirstName + ' ' + s.LastName AS [Student Full Name],
  	   AVG(ss.Grade) AS AverageGrade,
  	   su.Name AS SubjectName
    FROM Teachers AS t 
    JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
    JOIN Students AS s ON s.Id = st.StudentId
    JOIN StudentsSubjects AS ss ON ss.StudentId = s.Id
    JOIN Subjects AS su ON su.Id = ss.SubjectId AND su.Id = t.SubjectId
GROUP BY t.FirstName, t.LastName, s.FirstName, s.LastName, su.Name
) AS [Inner Query]
) AS [Ranking Query]
   WHERE RowNumber = 1 
ORDER BY SubjectName,[Teacher Full Name], TopGrade DESC

/*---16---*/
SELECT s.[Name],AVG(Grade) AS [AverageGrade]  FROM Subjects AS s
JOIN StudentsSubjects AS ss
ON s.Id=ss.SubjectId
GROUP BY s.Id,s.[Name]
ORDER BY s.Id

/*---17---*/
SELECT [Quarter], 
		[SubjectName], 
		COUNT(StudentId) AS StudentsCount
		FROM (			SELECT s.[Name] AS SubjectName,
						se.StudentId,
						CASE
						WHEN DATEPART(MONTH, Date) BETWEEN 1 AND 3 THEN 'Q1'
						WHEN DATEPART(MONTH, Date) BETWEEN 4 AND 6 THEN 'Q2'
						WHEN DATEPART(MONTH, Date) BETWEEN 7 AND 9 THEN 'Q3'
						WHEN DATEPART(MONTH, Date) BETWEEN 10 AND 12 THEN 'Q4'
						WHEN Date IS NULL THEN 'TBA'
						END AS [Quarter]
				FROM Exams AS e
				JOIN Subjects AS s 
				ON s.Id = e.SubjectId 
				JOIN StudentsExams AS se 
				ON se.ExamId = e.Id
				WHERE se.Grade >= 4 ) AS [Quaters Query]
GROUP BY [Quarter], [SubjectName]
ORDER BY [Quarter]

/*---18---*/
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(5,2))
RETURNS VARCHAR(MAX)
AS
BEGIN
	IF(@studentId NOT BETWEEN 1 AND 120) 
	RETURN 'The student with provided id does not exist in the school!'
	IF(@grade>6.00)
	RETURN 'Grade cannot be above 6.00!'
	ELSE
	BEGIN RETURN CAST('You have to update ' + CAST((SELECT COUNT(Grade) FROM Students AS s
	JOIN StudentsExams AS se
	ON s.Id=se.StudentId
	WHERE se.Grade >= @grade AND se.Grade <= @grade+0.50 AND s.Id=@studentId
	GROUP BY se.StudentId) AS VARCHAR(10) ) + ' grades for the student ' + (SELECT FirstName FROM Students WHERE Id=@studentId) AS VARCHAR(MAX))
	END
	RETURN ' ';
END

/*---19---*/
CREATE PROC usp_ExcludeFromSchool(@StudentId INT)
AS
IF(@StudentId BETWEEN 1 AND 120)
BEGIN
DELETE FROM StudentsExams
WHERE StudentId=@StudentId
DELETE FROM StudentsTeachers
WHERE StudentId=@StudentId
DELETE StudentsSubjects
WHERE StudentId=@StudentId
DELETE FROM Students
WHERE Id=@StudentId
END
ELSE
RAISERROR('This school has no student with the provided id!',16,1)


--EXEC usp_ExcludeFromSchool 301

--EXEC usp_ExcludeFromSchool 1
--SELECT COUNT(*) FROM Students

/*---20---*/
--CREATE TABLE ExcludedStudents
--(
--StudentId INT, 
--StudentName VARCHAR(30)
--)

--GO
CREATE TRIGGER tr_StudentsDelete ON Students
INSTEAD OF DELETE
AS
INSERT INTO ExcludedStudents(StudentId, StudentName)
		SELECT Id, FirstName + ' ' + LastName FROM deleted

