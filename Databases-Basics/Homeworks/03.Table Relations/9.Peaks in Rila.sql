USE [Geography]

SELECT MountainRange,PeakName,Elevation FROM Peaks AS pe
JOIN Mountains AS ma
ON pe.MountainId=ma.Id
WHERE MountainRange='Rila'
ORDER BY Elevation DESC

