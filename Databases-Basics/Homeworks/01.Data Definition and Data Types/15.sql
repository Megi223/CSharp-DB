CREATE DATABASE Hotels
USE Hotels

CREATE TABLE Employees
(
   Id INT PRIMARY KEY NOT NULL,
   FirstName VARCHAR(15) NOT NULL,
   LastName VARCHAR(15) NOT NULL,
   Title VARCHAR(15) NOT NULL,
   Notes VARCHAR(200)
)
CREATE TABLE Customers
(
   AccountNumber INT PRIMARY KEY NOT NULL,
   FirstName VARCHAR(15) NOT NULL,
   LastName VARCHAR(15) NOT NULL,
   PhoneNumber VARCHAR(10) NOT NULL,
   EmergencyName VARCHAR(15) NOT NULL,
   EmergencyNumber VARCHAR(10) NOT NULL,
   Notes VARCHAR(200)
)
CREATE TABLE RoomStatus
(
   RoomStatus VARCHAR(4) PRIMARY KEY NOT NULL,
   Notes VARCHAR(200)
)
CREATE TABLE RoomTypes
(
   RoomType VARCHAR(10) PRIMARY KEY NOT NULL,
   Notes VARCHAR(200)
)
CREATE TABLE BedTypes
(
   BedType VARCHAR(10) PRIMARY KEY NOT NULL,
   Notes VARCHAR(200)
)
CREATE TABLE Rooms
(
   RoomNumber VARCHAR(10) PRIMARY KEY NOT NULL,
   RoomType VARCHAR(10) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
   BedType VARCHAR(10) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
   Rate DECIMAL(3,2),
   RoomStatus VARCHAR(4) FOREIGN KEY REFERENCES RoomStatus(RoomStatus) NOT NULL,
   Notes VARCHAR(200)
)

CREATE TABLE Payments
(
   Id INT PRIMARY KEY NOT  NULL,
   EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
   PaymentDate DATE NOT NULL,
   AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
   FirstDateOccupied DATE NOT NULL,
   LastDateOccupied DATE NOT NULL,
   TotalDays INT NOT NULL,
   AmountCharged DECIMAL(5,2) NOT NULL,
   TaxRate DECIMAL(3,2) NOT NULL,
   PaymentTotal DECIMAL(5,2) NOT NULL,
   Notes VARCHAR(200)
)


CREATE TABLE Occupancies
(
   Id INT PRIMARY KEY NOT NULL,
   EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
   DateOccupied DATE NOT NULL,
   AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
   RoomNumber VARCHAR(10) FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
   RateApplied DECIMAL(3,2),
   PhoneCharge DECIMAL(5,2) NOT NULL,
   Notes VARCHAR(200)
)

INSERT INTO BedTypes(BedType)
VALUES 
('Double'),
('Single'),
('Twin')

INSERT INTO Employees(Id,FirstName,LastName,Title)
VALUES
(1,'Pesho','Ivanov','Reception'),
(2,'Ivan','Ivanov','Cook'),
(3,'Misho','Petkov','Reception')

INSERT INTO Customers(AccountNumber,FirstName,LastName,PhoneNumber,EmergencyName,EmergencyNumber)
VALUES
(1,'Pesho','Ivanov','0885789742','Police','911'),
(2,'Pesho','Ivanov','0885789742','Police','911'),
(3,'Pesho','Ivanov','0885789742','Police','911')

INSERT INTO RoomStatus(RoomStatus)
VALUES 
('Busy'),
('Free'),
('Rent')

INSERT INTO RoomTypes(RoomType)
VALUES
('Apartment'),
('Suite'),
('Single')

INSERT INTO Rooms(RoomNumber,RoomType,BedType,RoomStatus)
VALUES
('123','Apartment','Double','Rent'),
('456','Suite','Twin','Busy'),
('789','Single','Single','Free')

INSERT INTO Payments(Id,EmployeeId,PaymentDate,AccountNumber,
FirstDateOccupied,LastDateOccupied,TotalDays,AmountCharged,TaxRate,PaymentTotal)
VALUES
(1,1,'2020-05-23',1,'2020-05-22','2020-05-23',1,100,2,102),
(2,2,'2020-05-23',2,'2020-05-22','2020-05-23',1,100,2,102),
(3,3,'2020-05-23',3,'2020-05-22','2020-05-23',1,100,2,102)

INSERT INTO Occupancies(Id,EmployeeId,DateOccupied,AccountNumber,
RoomNumber,PhoneCharge)
VALUES
(1,1,'2020-05-23',1,'123',5.25),
(2,2,'2020-05-23',2,'456',5.25),
(3,3,'2020-05-23',3,'789',5.25)









