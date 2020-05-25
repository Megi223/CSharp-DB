/*---08---*/
USE Minions
CREATE TABLE Users
(
   Id INT PRIMARY KEY IDENTITY,
   Username VARCHAR(30) UNIQUE NOT NULL,
   [Password] VARCHAR(26) NOT NULL,
   ProfilePicture VARBINARY(MAX)
                  CHECK(DATALENGTH(ProfilePicture)<=900),
   LastLoginTime DATETIME,
   IsDeleted BIT NOT NULL
)

INSERT INTO Users(Username,[Password],IsDeleted)
VALUES
('PESHO',123456,1),
('PESHO1',123456,1),
('PESHO2',123456,1),
('PESHO3',123456,1),
('PESHO4',123456,1)

/*---09---*/
ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC07F1C6CDAC]

ALTER TABLE Users
ADD CONSTRAINT PK_USERS_CompositeIdUsername
PRIMARY KEY(Id,Username)

/*---10---*/
ALTER TABLE Users
ADD CHECK (LEN([Password])>=5); 

/*---11---*/
ALTER TABLE Users
ADD CONSTRAINT DF_USERS_LASTLOGINTIME
DEFAULT GETDATE() FOR LastLoginTime; 

/*---12---*/
ALTER TABLE Users
DROP CONSTRAINT PK_USERS_CompositeIdUsername

ALTER TABLE Users
ADD CONSTRAINT PK_USERS_Id
PRIMARY KEY(Id)

ALTER TABLE Users
ADD CONSTRAINT UC_Username UNIQUE (Username)