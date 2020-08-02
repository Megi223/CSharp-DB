CREATE DATABASE TripService

USE TripService

CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(20) NOT NULL,
	CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(30) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(10,2)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Price DECIMAL(18,2) NOT NULL,
	[Type] NVARCHAR(20) NOT NULL,
	Beds INT NOT NULL,
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL
)

CREATE TABLE Trips
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
	BookDate DATE NOT NULL,
	ArrivalDate DATE NOT NULL,
	ReturnDate DATE NOT NULL,
	CancelDate DATE,
	CONSTRAINT CK_BookDateArrivalDate CHECK (BookDate < ArrivalDate),
	CONSTRAINT CK_ArrivalDateReturnDate CHECK (ArrivalDate < ReturnDate)
)

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
	BirthDate DATE NOT NULL,
	Email VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips
(
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id) NOT NULL,
	TripId INT FOREIGN KEY REFERENCES Trips(Id) NOT NULL,
	Luggage INT NOT NULL
	CHECK(Luggage >= 0),
	PRIMARY KEY(AccountId,TripId)
)

/*---02---*/
INSERT INTO Accounts(FirstName,MiddleName,LastName,CityId,BirthDate,Email)
VALUES
('John','Smith','Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',2,'1844-10-15','f_nietzsche@softuni.bg')

INSERT INTO Trips(RoomId,BookDate,ArrivalDate,ReturnDate,CancelDate)
VALUES
(101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULL)

/*---03---*/
UPDATE Rooms
SET Price=Price*1.14
WHERE HotelId IN (5,7,9)

/*---04---*/--???
DELETE FROM Accounts
WHERE Id=47

DELETE FROM AccountsTrips
WHERE AccountId=47

/*---05---*/
SELECT FirstName,LastName,FORMAT(BirthDate,'MM-dd-yyyy') AS [BirthDate],c.[Name] AS Hometown,Email 
FROM Accounts AS a
JOIN Cities AS c
ON c.Id=a.CityId
WHERE Email LIKE 'e%'
ORDER BY c.[Name] ASC

/*---06---*/
SELECT c.[Name] AS [City],COUNT(*) AS [Hotels] FROM Cities AS c
JOIN Hotels AS h
ON c.Id=h.CityId
GROUP BY c.[Name]
ORDER BY [Hotels] DESC,[City]

/*---07---*/
SELECT a.Id AS [AccountId],
		FirstName + ' ' + LastName AS [FullName],
		MAX(DATEDIFF(DAY,ArrivalDate,ReturnDate)) AS [LongestTrip],
		MIN(DATEDIFF(DAY,ArrivalDate,ReturnDate)) AS [ShortestTrip]
FROM Accounts AS a
JOIN AccountsTrips AS atr
ON atr.AccountId=a.Id
JOIN Trips AS t
ON t.Id=atr.TripId
WHERE (MiddleName IS NULL) AND (CancelDate IS NULL)
GROUP BY a.Id,FirstName,LastName
ORDER BY [LongestTrip] DESC, ShortestTrip ASC

/*---08---*/
SELECT TOP(10) c.Id, c.[Name] AS [City], c.CountryCode AS [Country],COUNT(a.Id) AS [Accounts]
FROM Cities AS c
JOIN Accounts AS a
ON a.CityId=c.Id
GROUP BY c.Id,c.[Name],c.CountryCode
ORDER BY [Accounts] DESC

/*---09---*/
SELECT a.Id,Email,c.Name AS [City],COUNT(*) AS [Trips] FROM Accounts AS a
JOIN AccountsTrips AS atr
ON atr.AccountId=a.Id
JOIN Trips AS t
ON atr.TripId=t.Id
JOIN Rooms AS r
ON t.RoomId=r.Id
JOIN Hotels AS h
ON h.Id=r.HotelId
JOIN Cities AS c
ON c.Id=h.CityId
WHERE a.CityId=h.CityId
GROUP BY a.Id,Email,c.[Name]
ORDER BY [Trips] DESC,a.Id




/*---12---*/
CREATE PROC usp_SwitchRoom @TripId INT, @TargetRoomId INT
AS
BEGIN
    DECLARE @CurrentRoom INT = (SELECT TOP(1) RoomId FROM Trips WHERE Id = @TripId)
 
    IF (SELECT TOP(1) HotelId FROM Rooms WHERE Id = @CurrentRoom) !=
       (SELECT TOP(1) HotelId FROM Rooms WHERE Id = @TargetRoomId)
        BEGIN
            THROW 51000, 'Target room is in another hotel!', 1
        END
   
    IF (SELECT Beds FROM Rooms WHERE Id = @TargetRoomId) <
       (
        SELECT COUNT(*) AS AccountsOnTrip
        FROM Trips AS t
        JOIN AccountsTrips AS at ON t.Id = at.TripId
        WHERE t.Id = @TripId
        GROUP BY t.Id
       )
       BEGIN
            THROW 51001, 'Not enough beds in target room!', 1
       END
 
       UPDATE Trips
       SET RoomId = @TargetRoomId
       WHERE Id = @TripId
END


/*---10---*/
SELECT t.Id,CONCAT(FirstName , ' ',ISNULL(MiddleName + ' ','') , LastName) AS [Full Name],
c1.[Name] AS [From],
c2.[Name] AS [To],
CASE 
		WHEN CancelDate IS NOT NULL THEN 'Canceled'
		ELSE CONCAT(DATEDIFF(DAY,ArrivalDate,ReturnDate),' days') 
		END AS [Duration]

FROM Trips AS t
JOIN AccountsTrips AS atr
ON atr.TripId=t.Id
JOIN Accounts AS a
ON a.Id=atr.AccountId
JOIN Rooms AS r
ON r.Id=t.RoomId
JOIN Hotels AS h
ON h.Id=r.HotelId
JOIN Cities AS c1
ON c1.Id=a.CityId
JOIN Cities AS c2
ON c2.Id=h.CityId
ORDER BY [Full Name],t.Id

/*---11---*/
CREATE FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @hotelBaseRate DECIMAL(18,2)
    SET @hotelBaseRate = (SELECT Hotels.BaseRate FROM Hotels WHERE Hotels.Id = @HotelId)
 
    DECLARE @roomId INT
    SET @roomId = (SELECT TOP(1) tempDB.roomId
                    FROM(
                    SELECT Rooms.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                    FROM Rooms
                    JOIN Hotels ON Hotels.Id = Rooms.HotelId
                    JOIN Trips ON Trips.RoomId = Rooms.Id
                    WHERE Hotels.Id = @HotelId AND Rooms.Beds >= @People ) as tempDB
                    WHERE NOT EXISTS (SELECT tempDBTwo.roomId
                                FROM(
                                SELECT RoomsTwo.Id AS roomId, Price, [Type], Beds, ArrivalDate, ReturnDate, CancelDate
                                FROM Rooms as RoomsTwo
                                JOIN Hotels AS HotelsTwo ON HotelsTwo.Id = RoomsTwo.HotelId
                                JOIN Trips AS TripsTwo ON TripsTwo.RoomId = RoomsTwo.Id
                                WHERE HotelsTwo.Id = @HotelId AND RoomsTwo.Beds >= @People ) as tempDBTwo
                                WHERE (CancelDate IS NULL AND @Date > ArrivalDate AND @Date < ReturnDate))
                    ORDER BY tempDB.Price DESC)
 
    IF(@roomId IS NULL) RETURN 'No rooms available'
 
    DECLARE @highestPrice DECIMAL(18,2)
    SET @highestPrice = (SELECT Rooms.Price FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @roomType NVARCHAR(200);
    SET @roomType = (SELECT Rooms.[Type] FROM Rooms WHERE Rooms.Id = @roomId);
 
    DECLARE @roomBeds INT
    SET @roomBeds = (SELECT Rooms.Beds FROM Rooms WHERE Rooms.Id = @roomId)
 
    DECLARE @totalPrice DECIMAL(18,2)  
    SET @totalPrice = (@hotelBaseRate + @highestPrice) * @People
    RETURN FORMATMESSAGE('Room %i: %s (%i beds) - $%s', @roomId, @roomType, @roomBeds, CONVERT(NVARCHAR(100),@totalPrice))
END

