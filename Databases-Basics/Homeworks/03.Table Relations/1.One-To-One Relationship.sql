CREATE DATABASE TableRelations

USE TableRelations

CREATE TABLE Passports
(
   PasspportID INT PRIMARY KEY IDENTITY(101,1),
   PassportNumber VARCHAR(8) NOT NULL
)

CREATE TABLE Persons
(
   PersonID INT PRIMARY KEY IDENTITY,
   FirstName VARCHAR(20) NOT NULL,
   Salary DECIMAL(7,2) NOT NULL,
   PassportID INT FOREIGN KEY REFERENCES Passports(PasspportID) NOT NULL UNIQUE
)

INSERT INTO Passports(PassportNumber)
VALUES 
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons(FirstName,Salary,PassportID)
VALUES 
('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)



