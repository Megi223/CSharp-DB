CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories
(
   Id INT PRIMARY KEY NOT NULL,
   CategoryName VARCHAR(20) NOT NULL,
   DailyRate DECIMAL(3,2),
   WeeklyRate DECIMAL(3,2),
   MonthlyRate DECIMAL(3,2),
   WeekendRate DECIMAL(3,2)
)
CREATE TABLE Cars
(
   Id INT PRIMARY KEY NOT NULL,
   PlateNumber VARCHAR(10) UNIQUE NOT NULL,
   Manufacturer VARCHAR(20) NOT NULL,
   Model VARCHAR(10) NOT NULL,
   CarYear SMALLINT NOT NULL,
   CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
   Doors TINYINT NOT NULL,
   Picture VARBINARY(MAX),
   Condition VARCHAR(10) NOT NULL,
   Available VARCHAR(3) NOT NULL,
)
CREATE TABLE Employees
(
  Id INT PRIMARY KEY NOT NULL,
  FirstName VARCHAR(10) NOT NULL,
  LastName VARCHAR(10) NOT NULL,
  Title VARCHAR(30) NOT NULL,
  Notes VARCHAR(200)
)
CREATE TABLE Customers
(
  Id INT PRIMARY KEY NOT NULL,
  DriverLicenceNumber VARCHAR(20) UNIQUE NOT NULL,
  FullName VARCHAR(30) NOT NULL,
  [Address] VARCHAR(30) NOT NULL,
  City VARCHAR(30) NOT NULL,
  ZIPCode VARCHAR(30) NOT NULL,
  Notes VARCHAR(200)
)
CREATE TABLE RentalOrders
(
  Id INT PRIMARY KEY NOT NULL,
  EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
  CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
  CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL,
  TankLevel INT NOT NULL,
  KilometrageStart INT NOT NULL,
  KilometrageEnd INT NOT NULL,
  TotalKilometrage INT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  TotalDays SMALLINT NOT NULL,
  RateApplied DECIMAL(3,2),
  TaxRate DECIMAL(3,2),
  OrderStatus VARCHAR(10) NOT NULL,
  Notes VARCHAR(200)
)

INSERT INTO Categories(Id,CategoryName)
VALUES 
(1,'Race'),
(2,'Race'),
(3,'Race')

INSERT INTO Cars(Id,PlateNumber,Manufacturer,Model,CarYear,CategoryId,Doors,Condition,Available)
VALUES 
(1,'SA1234SA','Germany','X5',2005,1,5,'New','Yes'),
(2,'SA4567SA','Germany','X5',2005,1,5,'Used','Yes'),
(3,'SA7890SA','Germany','X5',2005,1,5,'New','No')

INSERT INTO Employees(Id,FirstName,LastName,Title)
VALUES 
(1,'Peter','Thompson', 'Engineer'),
(2,'Ivan','Thompson', 'Technician'),
(3,'Ana','Parker', 'Engineer')

INSERT INTO Customers(Id,DriverLicenceNumber,FullName,[Address],City,ZIPCode)
VALUES 
(1,'123456','Helene Smith','GreenStreet','London',5000),
(2,'494359','William Johnson','ParkStreet','Berlin',2555),
(3,'949294','Samantha Wilson','SecondStreet','London',5000)

INSERT INTO RentalOrders(Id,EmployeeId,CustomerId,CarId,
TankLevel,KilometrageStart,KilometrageEnd,TotalKilometrage,
StartDate,EndDate,TotalDays,OrderStatus)
VALUES 
(1,1,2,3,300,200,500,300,'2020-05-14','2020-05-21',7,'In process'),
(2,3,1,1,300,200,500,300,'2020-05-14','2020-05-21',7,'In process'),
(3,2,3,2,300,200,500,300,'2020-05-14','2020-05-21',7,'In process')


SELECT * FROM Categories
SELECT * FROM Cars
SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM RentalOrders








