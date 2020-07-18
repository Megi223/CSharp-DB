CREATE DATABASE Bitbucket

USE Bitbucket

/*---01---*/
CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors
(
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
	PRIMARY KEY(RepositoryId,ContributorId)
)

CREATE TABLE Issues
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Title VARCHAR(255) NOT NULL,
	IssueStatus CHAR(6) NOT NULL,
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	AssigneeId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Commits
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT FOREIGN KEY REFERENCES Issues(Id),
	RepositoryId INT FOREIGN KEY REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Files
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(10,2) NOT NULL,
	ParentId INT FOREIGN KEY REFERENCES Files(Id),
	CommitId INT FOREIGN KEY REFERENCES Commits(Id) NOT NULL 
)

/*---02---*/
INSERT INTO Files([Name],Size,ParentId,CommitId)
VALUES
('Trade.idk',2598.0,1,1),
('menu.net',9238.31,2,2),
('Administrate.soshy',1246.93,3,3),
('Controller.php',7353.15,4,4),
('Find.java',9957.86,5,5),
('Controller.json',14034.87,3,6),
('Operate.xix',7662.92,7,7)

INSERT INTO Issues(Title,IssueStatus,RepositoryId,AssigneeId)
VALUES
('Critical Problem with HomeController.cs file','open',1,4),
('Typo fix in Judge.html','open',4,3),
('Implement documentation for UsersService.cs','closed',8,2),
('Unreachable code in Index.cs','open',9,8)

/*---03---*/
UPDATE Issues
SET IssueStatus='closed'
WHERE AssigneeId=6

/*---04---*/
DELETE FROM RepositoriesContributors
WHERE RepositoryId= (SELECT Id FROM Repositories
						WHERE [Name]='Softuni-Teamwork')

DELETE FROM Issues
WHERE RepositoryId= (SELECT Id FROM Repositories
						WHERE [Name]='Softuni-Teamwork')

/*---05---*/
SELECT Id,[Message],RepositoryId,ContributorId 
FROM Commits
ORDER BY Id ASC, [Message] ASC,RepositoryId ASC,ContributorId ASC

/*---06---*/
SELECT Id,[Name],Size FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC,Id ASC, [Name] ASC

/*---07---*/
SELECT i.Id, u.Username + ' : ' + i.Title AS [IssueAssignee] 
FROM Issues AS i
JOIN Users AS u
ON i.AssigneeId=u.Id
ORDER BY i.Id DESC, IssueAssignee ASC

/*---08---*/
SELECT f2.Id,f2.[Name], CAST(f2.Size AS VARCHAR(20)) + 'KB' AS [Size]
FROM Files AS f1
RIGHT JOIN Files AS f2
ON f1.ParentId=f2.Id
WHERE f1.ParentId IS NULL
ORDER BY f1.Id ASC, f1.[Name] ASC,f1.Size DESC

/*---09---*/
SELECT TOP(5) r.Id,r.[Name],COUNT(*) AS [Commits]
FROM Repositories AS r
JOIN Commits AS c
ON r.Id=c.RepositoryId
JOIN RepositoriesContributors AS rc
ON r.Id=rc.RepositoryId
GROUP BY r.[Name],r.Id
ORDER BY Commits DESC,r.Id ASC,r.[Name] ASC

/*---10---*/
SELECT u.Username AS [Username],SUM(Size)/COUNT(Size) AS [Size] FROM Users AS u
JOIN Commits AS c
ON u.Id=c.ContributorId
JOIN Files AS f
ON f.CommitId=c.Id
GROUP BY u.Username
ORDER BY Size DESC,Username ASC

/*---11---*/
CREATE FUNCTION udf_UserTotalCommits(@username VARCHAR(20))
RETURNS INT
AS
BEGIN 
	RETURN (SELECT COUNT(Username) FROM Users AS u
	JOIN Commits AS c
	ON u.Id=c.ContributorId
	WHERE Username=@username)
END

/*---12---*/
GO
CREATE PROC usp_FindByExtension(@extension VARCHAR(10))
AS
SELECT Id,[Name],CAST(Size AS VARCHAR(20)) + 'KB' AS [Size]  FROM Files AS f
WHERE SUBSTRING ([Name],CHARINDEX('.',[Name],1)+1,LEN([Name]))=@extension
ORDER BY Id ASC,[Name] ASC,f.Size DESC