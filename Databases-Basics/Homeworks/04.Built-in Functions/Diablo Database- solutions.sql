USE Diablo

/*---13---*/
SELECT TOP(50) [Name],FORMAT([Start],'yyyy-MM-dd') AS [Start] FROM Games
WHERE YEAR([START]) IN (2011,2012)
ORDER BY [Start],[Name]

/*---14---*/
SELECT Username,SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider] 
FROM Users
ORDER BY [Email Provider],Username

/*---15---*/
SELECT Username,IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1%_.%_.___'
ORDER BY Username

/*---16---*/
SELECT [Name],
	CASE 
		WHEN DATEPART(HOUR,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(HOUR,[Start]) BETWEEN 18 AND 23 THEN 'Evening'
	END AS [Part of the Day],
	CASE 
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS [Duration]
FROM Games
ORDER BY [Name],[Duration],[Part of the Day]

