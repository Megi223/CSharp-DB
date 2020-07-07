USE Gringotts

/*---01---*/
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

/*---02---*/
SELECT MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits

/*---03---*/
SELECT DepositGroup,MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY DepositGroup

/*---04---*/
SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

/*---05---*/
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup

/*---06---*/
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup

/*---07---*/
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount)<150000
ORDER BY TotalSum DESC

/*---08---*/
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge) AS [MinDepositCharge]
FROM WizzardDeposits
GROUP BY DepositGroup,MagicWandCreator

/*---09---*/
---First way- the inner query makes several age grous based on the age
---and the other query sorts them by their age groups and returns also the 
---sum of all objects in every singe age group
SELECT AgeGroup,SUM(WizardCount) AS [WizardCount] FROM 
(SELECT 
CASE
WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
WHEN Age > 60 THEN '[61+]'
END AS [AgeGroup],
COUNT(*) AS [WizardCount]
FROM WizzardDeposits
GROUP BY Age ) AS [GroupingQuery]
GROUP BY AgeGroup

---Second way- the inner query writes next to each object in which 
---age group it is and the other query sorts them by the age group
SELECT AgeGroup,COUNT(AgeGroup) FROM 
(SELECT 
CASE
WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
WHEN Age > 60 THEN '[61+]'
END AS [AgeGroup]
FROM WizzardDeposits
) AS [AgeQuery]
GROUP BY AgeGroup

/*---10---*/
---First way- with GROUP BY for uniqueness 
SELECT SUBSTRING(FirstName,1,1) AS [FirstLetter]
FROM WizzardDeposits
WHERE DepositGroup='Troll Chest'
GROUP BY SUBSTRING(FirstName,1,1)

---Second way- with DISTINCT for uniqueness
SELECT DISTINCT SUBSTRING(FirstName,1,1) AS [FirstLetter]
FROM WizzardDeposits
WHERE DepositGroup='Troll Chest'

/*---11---*/
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) FROM WizzardDeposits
WHERE DepositStartDate> '1985-01-01'
GROUP BY DepositGroup,IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

/*---12---*/
SELECT SUM([Difference]) AS [SumDifference] 
FROM (
		SELECT FirstName AS [Host Wizard],
				DepositAmount AS [Host Wizard Deposit],
				LEAD(FirstName) OVER(ORDER BY Id ASC) AS [Guest Wizard],
				LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Guest Wizard Deposit],
				DepositAmount-LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Difference]
		FROM WizzardDeposits 
	 ) AS [DiffQuery]







