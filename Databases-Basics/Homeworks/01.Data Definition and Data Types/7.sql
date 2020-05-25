*/---07---*/

CREATE TABLE People
(
   Id INT PRIMARY KEY IDENTITY,
   [Name] NVARCHAR(200) NOT NULL,
   Picture VARBINARY(MAX)
          CHECK(DATALENGTH(Picture)<=2*1048576),
   Height DECIMAL(3,2),
   [Weight] DECIMAL(5,2),
   Gender CHAR(1) CHECK(GENDER = 'm' OR GENDER = 'f') NOT NULL,
   Birthdate DATE NOT NULL,
   Biography NVARCHAR(MAX)
)

INSERT INTO People([Name],Height,[Weight],Gender,Birthdate)
VALUES
   ('PESHO',1.70,80,'m','05.25.1999'),
   ('PESHO',1.70,80,'m','05.25.1999'),   
   ('PESHO',1.70,80,'m','05.25.1999'),
   ('PESHO',1.70,80,'m','05.25.1999'),   
   ('PESHO',1.70,80,'m','05.25.1999')   

