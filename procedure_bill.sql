CREATE OR REPLACE PROCEDURE procedure_bill (mydate DATE["MM/YYYY"])
IS
	CURSOR all_clients (myClient, myDate, myProduct) IS
	SELECT *
  FROM contracts
  JOIN clients ON (CONTRACTS.clientId = CLIENTS.clientId)
  JOIN invoices ON (CONTRACTS.clientId = INVOICES.idcontract)
  JOIN products
  WHERE ((sysdate >= startdate) AND (sysdate <= enddate)) OR
        ((sysdate >= startdate) AND (enddate IS NULL))
BEGIN
FOR clientId IN all_clients LOOP
     INSERT INTO invoices (amount) VALUES (function_bill(ALL_CLIENTS.myClient, ALL_CLIENTS.myDate, ALL_CLIENTS.myProduct));
	END LOOP;
--EXCEPTION
--WHEN /*too many rows*/ THEN
--error-treatment-1;
--WHEN /*no data found*/ THEN
--error-treatment-2;
END [procedure_bill];
/
