--Exam Preparation 1

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
SELECT * FROM Planes
WHERE [Name] LIKE '%tr%'
ORDER BY Id,[Name],Seats,[Range]

/*---06---*/
SELECT FlightId,SUM(Price) AS [Price] FROM Tickets
GROUP BY FlightId
ORDER BY [Price] DESC, FlightId ASC

/*---07---*/
SELECT p.FirstName + ' ' + p.LastName AS [Full Name],
		Origin,
		Destination
FROM Passengers AS p
JOIN Tickets AS t
ON p.Id=t.PassengerId
JOIN Flights AS f
ON t.FlightId=f.Id
ORDER BY [Full Name],Origin,Destination

/*---08---*/
SELECT FirstName AS [First Name],
		LastName AS [Last Name],
		Age 
FROM Passengers AS p
LEFT JOIN Tickets AS t
ON p.Id=t.PassengerId
WHERE FlightId IS NULL
ORDER BY Age DESC,FirstName ASC,LastName ASC

/*---09---*/
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

/*---10---*/
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

/*---11---*/
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

/*---12---*/
CREATE PROC usp_CancelFlights
AS
UPDATE Flights
SET ArrivalTime=NULL, DepartureTime=NULL 
WHERE ArrivalTime>DepartureTime

