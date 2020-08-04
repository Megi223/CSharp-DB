CREATE DATABASE ColonialJourney

USE ColonialJourney

/*---01---*/
CREATE TABLE Planets
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PlanetId INT FOREIGN KEY REFERENCES Planets(Id) NOT NULL
)

CREATE TABLE Spaceships
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Manufacturer VARCHAR(30) NOT NULL,
	LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Ucn VARCHAR(10) UNIQUE NOT NULL,
	BirthDate DATE NOT NULL
)

CREATE TABLE Journeys
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	JourneyStart DATETIME NOT NULL,
	JourneyEnd DATETIME NOT NULL,
	Purpose VARCHAR(11)
	CHECK(Purpose='Medical' OR Purpose='Technical' OR Purpose='Educational' OR Purpose='Military' OR Purpose IS NULL),
	DestinationSpaceportId INT FOREIGN KEY REFERENCES Spaceports(Id) NOT NULL,
	SpaceshipId INT FOREIGN KEY REFERENCES Spaceships(Id) NOT NULL
)

CREATE TABLE TravelCards
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CardNumber CHAR(10) UNIQUE NOT NULL,
	JobDuringJourney VARCHAR(8)
	CHECK(JobDuringJourney='Pilot' OR JobDuringJourney='Engineer' OR JobDuringJourney='Trooper'
	OR JobDuringJourney='Cleaner' OR JobDuringJourney='Cook' OR JobDuringJourney IS NULL),
	ColonistId INT FOREIGN KEY REFERENCES Colonists(Id) NOT NULL,
	JourneyId INT FOREIGN KEY REFERENCES Journeys(Id) NOT NULL
)

/*---02---*/
INSERT INTO Planets([Name])
VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO Spaceships([Name],[Manufacturer],LightSpeedRate)
VALUES
('Golf','VW',3),
('WakaWaka','Wakanda',4),
('Falcon9','SpaceX',1),
('Bed','Vidolov',6)

/*---03---*/
UPDATE Spaceships
SET LightSpeedRate=LightSpeedRate+1
WHERE Id BETWEEN 8 AND 12

/*---04---*/
DELETE FROM TravelCards
WHERE JourneyId = 1
DELETE FROM TravelCards
WHERE JourneyId = 2
DELETE FROM TravelCards
WHERE JourneyId = 3

DELETE FROM Journeys
WHERE Id=1
DELETE FROM Journeys
WHERE Id=2
DELETE FROM Journeys
WHERE Id=3

/*---05---*/
SELECT Id,FORMAT(JourneyStart,'dd/MM/yyyy') AS JourneyStart ,FORMAT(JourneyEnd,'dd/MM/yyyy') AS JourneyEnd FROM Journeys 
WHERE Purpose='Military'
ORDER BY JourneyStart

/*---06---*/
SELECT c.Id AS [id],c.FirstName + ' ' + c.LastName AS [full_name] FROM TravelCards AS tc
JOIN Colonists AS c
ON tc.ColonistId=c.Id
WHERE JobDuringJourney='Pilot'
ORDER BY c.Id ASC

/*---07---*/
SELECT COUNT(*) AS [count] FROM Colonists AS c
LEFT JOIN TravelCards AS tc
ON c.Id=tc.ColonistId
LEFT JOIN Journeys AS j
ON j.Id=tc.JourneyId
WHERE j.Purpose='Technical'

/*---08---*/
SELECT s.[Name],s.Manufacturer  
FROM Spaceships AS s
JOIN Journeys AS j
ON s.Id=j.SpaceshipId
JOIN TravelCards AS tc
ON tc.JourneyId=j.Id
JOIN Colonists AS c
ON c.Id=tc.ColonistId
WHERE DATEDIFF(YEAR,BirthDate,'2019-01-01')<30 AND JobDuringJourney='Pilot'
GROUP BY s.[Name],s.Manufacturer 
ORDER BY s.[Name] ASC

/*---09--*/
SELECT p.[Name] AS [PlanetName], COUNT(*) AS [JourneysCount] FROM Planets AS p
JOIN Spaceports AS s
ON p.Id=s.PlanetId
JOIN Journeys AS j
ON j.DestinationSpaceportId=s.Id
GROUP BY p.[Name]
ORDER BY JourneysCount DESC,PlanetName ASC

/*---10--*/
SELECT JobDuringJourney,FirstName + ' ' +LastName AS [FullName],[Rank] AS [JobRank] FROM (SELECT *,DENSE_RANK() OVER(PARTITION BY JobDuringJourney ORDER BY BirthDate) AS [Rank]
FROM (SELECT c.FirstName AS [FirstName],c.LastName,JobDuringJourney,BirthDate
			FROM Colonists AS c
			JOIN TravelCards AS tc
			ON c.Id=tc.ColonistId
			GROUP BY JobDuringJourney,c.BirthDate,FirstName,LastName
			
			) AS [GetOldestPeopleQuery]) AS [RankingQuery]
WHERE [Rank]=2

/*---11---*/
CREATE FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR(30)) 
RETURNS INT 
AS
BEGIN
DECLARE @Count INT =(SELECT COUNT(*) FROM Planets AS p
JOIN Spaceports AS s
ON p.Id=s.PlanetId
JOIN Journeys AS j
ON j.DestinationSpaceportId=s.Id
JOIN TravelCards AS tc
ON tc.JourneyId=j.Id
JOIN Colonists AS c
ON c.Id=tc.ColonistId
WHERE p.[Name]=@PlanetName)
RETURN CAST(@Count AS VARCHAR(30))
END

/*---12---*/
CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(50))
AS
BEGIN
	IF(@JourneyId NOT BETWEEN 1 AND 15)
	RAISERROR ('The journey does not exist!',16,1)
	IF((SELECT Purpose FROM Journeys
	WHERE Id=@JourneyId)=@NewPurpose)
    RAISERROR ('You cannot change the purpose!',16,1)
	ELSE
	UPDATE Journeys 
	SET Purpose=@NewPurpose
	WHERE Id= @JourneyId
END



