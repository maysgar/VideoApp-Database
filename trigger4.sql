--Prevent contract overlapping: if a client with an effective contract signs a new one, the
--former will end the day before the new one becomes effective Update dates in contracts.

--different contractId, startddate, enddate, contract_type

CREATE TRIGGER no_overlapping
ON contracts
FOR UPDATE
AS
IF UPDATE(startdate)
BEGIN
enddate = (UPDATE(startdate) - 1)
update contracts set enddate= UPDATE(startdate) - 1 --updated.startdate??? inserted.startdate??

DECLARE
old_contract_type VARCHAR2(50);
old_startdate DATE;
old_enddate DATE;

BEGIN
SELECT contract_type, startdate, enddate INTO old_contract_type, old_startdate, old_enddate FROM contracts
IF  (there is a new contract) THEN (old_enddate = new_startdate - 1)

END no_overlapping;
