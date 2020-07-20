CREATE DATABASE Airport

USE Airport

/*---01---*/
CREATE TABLE Planes
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(30) NOT NULL,
	Seats INT NOT NULL,
	[Range] INT NOT NULL
)

CREATE TABLE Flights
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DepartureTime DATETIME,
	ArrivalTime DATETIME,
	Origin NVARCHAR(50) NOT NULL,
	Destination NVARCHAR(50) NOT NULL,
	PlaneId INT FOREIGN KEY REFERENCES Planes(Id) NOT NULL
)

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Age INT NOT NULL,
	[Address] NVARCHAR(30) NOT NULL,
	PassportId NVARCHAR(11) NOT NULL
)

CREATE TABLE LuggageTypes
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Type] NVARCHAR(30) NOT NULL
)

CREATE TABLE Luggages
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	LuggageTypeId INT FOREIGN KEY REFERENCES LuggageTypes(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL
)

CREATE TABLE Tickets
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	FlightId INT FOREIGN KEY REFERENCES Flights(Id) NOT NULL,
	LuggageId INT FOREIGN KEY REFERENCES Luggages(Id) NOT NULL,
	Price DECIMAL(18,2) NOT NULL
)

/*---02---*/
INSERT INTO Planes([Name],Seats,[Range])
VALUES
('Airbus 336',112,5132),
('Airbus 330',432,5325),
('Boeing 369',231,2355),
('Stelt 297',254,2143),
('Boeing 338',165,5111),
('Airbus 558',387,1342),
('Boeing 128',345,5541)


INSERT INTO LuggageTypes([Type])
VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

/*---03---*/
UPDATE Tickets
SET Price=Price*1.13
WHERE FlightId=41

/*---04---*/
DELETE FROM Tickets
WHERE FlightId=30
DELETE FROM Flights
WHERE Destination='Ayn Halagim'

/*---05---*/
SELECT Origin,Destination FROM Flights
ORDER BY Origin,Destination

/*---06---*/
SELECT * FROM Planes
WHERE [Name] LIKE '%tr%'
ORDER BY Id,[Name],Seats,[Range]

/*---07---*/
SELECT FlightId,SUM(Price) AS [Price] FROM Tickets
GROUP BY FlightId
ORDER BY [Price] DESC, FlightId ASC

/*---08---*/
SELECT TOP(10) FirstName,LastName,Price 
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id=t.PassengerId
ORDER BY Price DESC,FirstName ASC,LastName ASC

/*---09---*/
SELECT lt.[Type],COUNT(*) AS [MostUsedLuggage] FROM Luggages AS l
JOIN LuggageTypes AS lt
ON l.LuggageTypeId=lt.Id
JOIN Passengers AS p
ON p.Id=l.PassengerId
GROUP BY lt.[Type]
ORDER BY [MostUsedLuggage] DESC,lt.[Type] ASC

/*---10---*/
SELECT p.FirstName + ' ' + p.LastName AS [Full Name],
		Origin,
		Destination
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id=t.PassengerId
JOIN Flights AS f
ON t.FlightId=f.Id
ORDER BY [Full Name],Origin,Destination

/*---11---*/
SELECT FirstName,LastName,Age 
FROM Passengers AS p
LEFT JOIN Tickets AS t
ON t.PassengerId=p.Id
WHERE t.Id IS NULL
ORDER BY Age DESC,FirstName ASC,LastName ASC

/*---12---*/
SELECT PassportId,[Address]
FROM Passengers AS p
LEFT JOIN Luggages AS l
ON l.PassengerId=p.Id
WHERE l.Id IS NULL
ORDER BY PassportId,[Address]

/*---13---*/
SELECT FirstName,LastName,COUNT(t.Id) AS [Total Trips] 
FROM Passengers AS p
LEFT JOIN Tickets AS t
ON t.PassengerId=p.Id
GROUP BY p.Id,FirstName,LastName
ORDER BY [Total Trips] DESC,FirstName,LastName

/*---14---*/
SELECT p.FirstName + ' ' + p.LastName AS [Full Name],
		pl.[Name] AS [Plane Name],
		f.Origin + ' - ' + f.Destination AS [Trip],
		lt.[Type] AS [Luggage Type]
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id=t.PassengerId
JOIN Luggages AS l
ON t.LuggageId=l.Id
JOIN LuggageTypes AS lt
ON l.LuggageTypeId=lt.Id
JOIN Flights AS f
ON f.Id=t.FlightId
JOIN Planes AS pl
ON f.PlaneId=pl.Id
ORDER BY [Full Name] ASC, 
		[Plane Name] ASC,
		Origin ASC,
		Destination ASC,
		[Luggage Type] ASC

/*---15---*/
SELECT FirstName AS [First Name],LastName AS [Last Name],Destination,Price FROM 
(SELECT FirstName,LastName,Destination,Price,DENSE_RANK() OVER(PARTITION BY p.Id ORDER BY Price DESC) AS [Rank]
FROM Passengers AS p
JOIN Tickets AS t
ON t.PassengerId=p.Id
JOIN Flights AS f
ON t.FlightId=f.Id
GROUP BY p.Id,FirstName,LastName,Destination,Price
) AS [Groupping and Ranking Query]
WHERE [Rank]=1
ORDER BY Price DESC,FirstName,LastName,Destination

/*---16---*/
SELECT Destination,COUNT(t.Id) AS [FilesCount] 
FROM Flights AS f
LEFT JOIN Tickets AS t
ON f.Id=t.FlightId
GROUP BY Destination
ORDER BY FilesCount DESC,Destination ASC

/*---17---*/
SELECT [Name],Seats AS [Seats],COUNT(PassengerId) AS [Passengers Count]
FROM Planes AS p
FULL OUTER JOIN Flights AS f
ON p.Id=f.PlaneId
FULL OUTER JOIN Tickets AS t
ON f.Id=t.FlightId
GROUP BY [Name],Seats
ORDER BY [Passengers Count] DESC,
			[Name] ASC,
			Seats ASC

/*---18---*/
CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(50), @destination VARCHAR(50), @peopleCount INT)
RETURNS VARCHAR(25)
AS
BEGIN
	IF @peopleCount<=0
	RETURN 'Invalid people count!';
	IF ((SELECT COUNT(*) FROM Flights WHERE Origin=@origin) = 0)
	RETURN 'Invalid flight!';
	IF ((SELECT COUNT(*) FROM Flights WHERE Destination=@destination) = 0)
	RETURN 'Invalid flight!';
	RETURN 'Total price ' + CAST(@peopleCount*(SELECT t.Price FROM Flights AS f
	JOIN Tickets AS t
	ON f.Id=t.FlightId
	WHERE Origin=@origin AND Destination=@destination) AS VARCHAR(25))
END

/*---19---*/
CREATE PROC usp_CancelFlights
AS
UPDATE Flights
SET ArrivalTime=NULL, DepartureTime=NULL 
WHERE ArrivalTime>DepartureTime

/*---20---*/
CREATE TABLE DeletedPlanes
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30),
Seats INT,
[Range] INT
)

GO

CREATE TRIGGER tr_DeletedPlanes ON Planes
FOR DELETE AS
  INSERT INTO DeletedPlanes(Id,[Name], Seats, [Range])
  SELECT d.Id, d.Name, d.Seats, d.Range FROM deleted AS d

GO





