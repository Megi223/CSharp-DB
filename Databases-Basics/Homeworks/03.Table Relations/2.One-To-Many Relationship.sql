USE TableRelations

CREATE TABLE Manufacturers
(
   ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   EstablishedOn DATE NOT NULL
)

CREATE TABLE Models
(
   ModelID INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL
)

INSERT INTO Manufacturers([Name],EstablishedOn)
VALUES
('BMW', '03/07/1916'),
('Tesla','01/01/2003'),
('Lada','05/01/1966')

INSERT INTO Models([Name],ManufacturerID)
VALUES
('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)