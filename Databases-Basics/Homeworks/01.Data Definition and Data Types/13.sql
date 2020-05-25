/*---13---*/
CREATE DATABASE Movies
USE Movies

CREATE TABLE Directors
(
   Id INT PRIMARY KEY NOT NULL,
   DirectorName VARCHAR(100) NOT NULL,
   Notes VARCHAR(500)
)

CREATE TABLE Genres
(
   Id INT PRIMARY KEY NOT NULL,
   GenreName VARCHAR(20) NOT NULL,
   Notes VARCHAR(500)
)

CREATE TABLE Categories
(
   Id INT PRIMARY KEY NOT NULL,
   CategoryName VARCHAR(20) NOT NULL,
   Notes VARCHAR(500)
)

CREATE TABLE Movies
(
   Id INT PRIMARY KEY NOT NULL,
   Title VARCHAR(50) NOT NULL,
   DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
   CopyrightYear SMALLINT,
   [Length] TINYINT NOT NULL,
   GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
   CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
   Rating DECIMAL(3,2),
   Notes VARCHAR(500)
)

INSERT INTO Directors(Id,DirectorName)
VALUES
(1,'Kevin Bray'),
(2,'Kevin Bray'),
(3,'Kevin Bray'),
(4,'Kevin Bray'),
(5,'Kevin Bray')

INSERT INTO Genres(Id,GenreName)
VALUES 
(1,'Comedy'),
(2,'Comedy'),
(3,'Comedy'),
(4,'Comedy'),
(5,'Comedy')

INSERT INTO Categories(Id,CategoryName)
VALUES 
(1,'For children'),
(2,'For children'),
(3,'For children'),
(4,'For children'),
(5,'For children')

INSERT INTO Movies(Id,Title,DirectorId,[Length],GenreId,CategoryId)
VALUES
(1,'Coming to America',1,75,2,3),
(2,'Coming to America',1,75,2,3),
(3,'Coming to America',1,75,2,3),
(4,'Coming to America',1,75,2,3),
(5,'Coming to America',1,75,2,3)


