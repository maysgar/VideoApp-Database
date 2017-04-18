--Prevent contract overlapping: if a client with an effective contract signs a new one, the
--former will end the day before the new one becomes effective Update dates in contracts.

--different contractId, startddate, enddate, contract_type

CREATE TRIGGER no_overlapping
AFTER INSERT OR UPDATE OF startdate ON contracts
FOR EACH ROW
BEGIN
IF UPDATE(startdate)
BEGIN
UPDATE contracts set enddate=  DATEADD(day,-1, :NEW.startdate)
WHERE enddate = :OLD.enddate;
END;


