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
SELECT FirstName,LastName,COUNT(st.TeacherId) FROM Students AS s
LEFT JOIN StudentsTeachers AS st
ON s.Id=st.StudentId
GROUP BY st.StudentId,FirstName,LastName
ORDER BY LastName

/*---07---*/
SELECT FirstName + ' ' + LastName AS [Full Name] FROM Students AS s
LEFT JOIN StudentsExams AS se
ON s.Id=se.StudentId
WHERE se.StudentId IS NULL
ORDER BY [Full Name]

/*---08---*/
SELECT TOP(10) FirstName AS [First Name],
		LastName AS [Last Name],
		CAST(AVG(Grade) AS DECIMAL(3,2)) AS [Grade]
FROM Students AS s
JOIN StudentsExams AS se
ON s.Id=se.StudentId
GROUP BY se.StudentId,FirstName,LastName
ORDER BY Grade DESC,FirstName ASC,LastName ASC

/*---09---*/
SELECT CONCAT(FirstName , ' ' ,MiddleName + ' ', LastName) AS [Full Name]
FROM Students AS s
LEFT JOIN StudentsSubjects AS ss
ON s.Id=ss.StudentId
WHERE ss.StudentId IS NULL
GROUP BY ss.StudentId,FirstName,MiddleName,LastName
ORDER BY [Full Name]

/*---10---*/
SELECT s.[Name],AVG(Grade) AS [AverageGrade]  FROM Subjects AS s
JOIN StudentsSubjects AS ss
ON s.Id=ss.SubjectId
GROUP BY s.Id,s.[Name]
ORDER BY s.Id

/*---11---*/
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

/*---12---*/
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




