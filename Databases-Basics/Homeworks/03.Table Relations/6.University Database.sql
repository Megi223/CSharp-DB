CREATE DATABASE University

USE University

CREATE TABLE Subjects
(
   SubjectID INT PRIMARY KEY NOT NULL,
   SubjectName VARCHAR(50) NOT NULL
)

CREATE TABLE Majors
(
   MajorID INT PRIMARY KEY NOT NULL,
   [Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Students
(
   StudentID INT PRIMARY KEY NOT NULL,
   StudentNumber INT NOT NULL,
   StudentName VARCHAR(50) NOT NULL,
   MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL
)

CREATE TABLE Payments
(
  PaymentID INT PRIMARY KEY NOT NULL,
  PaymentDate DATE NOT NULL,
  PaymentAmount DECIMAL(7,2) NOT NULL,
  StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL
)

CREATE TABLE Agenda
(
   StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
   SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID) NOT NULL,
   PRIMARY KEY(StudentID,SubjectID)
)