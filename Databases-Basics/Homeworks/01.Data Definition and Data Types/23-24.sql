USE Hotels
/*---23---*/

UPDATE Payments
SET TaxRate-=TaxRate*0.03

SELECT TaxRate FROM Payments

/*---24---*/
DELETE Occupancies
