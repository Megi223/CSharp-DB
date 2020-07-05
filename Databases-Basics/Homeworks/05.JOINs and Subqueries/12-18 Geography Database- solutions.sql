USE [Geography]

/*---12---*/
SELECT c.CountryCode,m.MountainRange,p.PeakName,p.Elevation 
FROM Countries AS c
INNER JOIN MountainsCountries AS mc
ON c.CountryCode=mc.CountryCode
INNER JOIN Mountains AS m
ON mc.MountainId=m.Id
INNER JOIN Peaks AS p
ON m.Id=p.MountainId
WHERE c.CountryCode='BG'AND p.Elevation>2835
ORDER BY p.Elevation DESC
     
/*---13---*/
SELECT mc.CountryCode,COUNT(MountainId) AS [MountainRanges]
FROM MountainsCountries AS mc
WHERE mc.CountryCode IN ('RU','BG','US')
GROUP BY CountryCode

/*---14---*/
SELECT TOP(5) c.CountryName,r.RiverName FROM Countries AS c
FULL OUTER JOIN CountriesRivers AS cr
ON c.CountryCode=cr.CountryCode
FULL OUTER JOIN Rivers AS r
ON r.Id=cr.RiverId
WHERE ContinentCode='AF'
ORDER BY c.CountryName ASC

/*---15---*/
SELECT ContinentCode,CurrencyCode,CurrencyCount AS [CurrencyUsage] 
FROM  (
					SELECT ContinentCode,CurrencyCode,
					[CurrencyCount],
					DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY CurrencyCount DESC) AS [Rank]
					FROM (
							SELECT ContinentCode,CurrencyCode,COUNT(*) AS [CurrencyCount]
							FROM Countries
							GROUP BY ContinentCode,CurrencyCode
						 ) AS [CurrencyCountQuery]
					WHERE CurrencyCount>1
		) AS [CurrencyRankingQuery]
WHERE [Rank]=1

/*---16---*/
SELECT COUNT(*) AS [Count]
FROM     
(       SELECT c.IsoCode FROM Countries AS c
		LEFT OUTER JOIN MountainsCountries AS mc
		ON c.CountryCode=mc.CountryCode
		WHERE mc.MountainId IS NULL
) AS [Countries with no mountains]

/*---17---*/
SELECT TOP(5) 
c.CountryName,
MAX(p.Elevation) AS [HighestPeakElevation],
MAX(r.[Length]) AS [LongestRiverLength]
FROM Countries AS c
LEFT OUTER JOIN MountainsCountries AS mc
ON c.CountryCode=mc.CountryCode
LEFT OUTER JOIN Peaks AS p
ON mc.MountainId=p.MountainId
LEFT OUTER JOIN CountriesRivers AS cr
ON c.CountryCode=cr.CountryCode
LEFT OUTER JOIN Rivers AS r
ON cr.RiverId=r.Id
GROUP BY c.CountryName
ORDER BY MAX(p.Elevation) DESC, 
			MAX(r.[Length]) DESC, 
			c.CountryName ASC

/*---18---*/
SELECT TOP(5) Country,
		CASE 
WHEN PeakName IS NULL THEN '(no highest peak)'
ELSE PeakName
END AS [Highest Peak Name],
CASE 
WHEN Elevation IS NULL THEN 0
ELSE Elevation
END AS [Highest Peak Elevation],
CASE 
WHEN MountainRange IS NULL THEN '(no mountain)'
ELSE MountainRange
END AS [Mountain] FROM
						( SELECT *,
						DENSE_RANK() OVER(PARTITION BY [Country] ORDER BY [Elevation] DESC) AS [PeakRank]
									FROM
									(   SELECT CountryName AS [Country],
												p.PeakName,
												p.Elevation,
												m.MountainRange
										FROM Countries AS c
										LEFT OUTER JOIN MountainsCountries AS mc
										ON c.CountryCode=mc.CountryCode
										LEFT OUTER JOIN Mountains AS m
										ON mc.MountainId=m.Id
										LEFT OUTER JOIN Peaks AS p
										ON m.Id=p.MountainId
									) AS [FullInfoQuery]
						) AS [PeakRankingsQuery]
WHERE [PeakRank]=1




