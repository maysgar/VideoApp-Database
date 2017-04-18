--b) Prevent non-valid visualizations regarding contracts (there cannot be taps in a date out of
--contract). 

CREATE TRIGGER non_valid_visualizations
AFTER INSERT OR UPDATE OF ++++++ ON contracts
FOR EACH ROW
BEGIN
DECLARE end_date DATE;
				bad_date EXCEPTION;

BEGIN 
	SELECT enddate INTO end_date FROM contracts
	 IF view_datetime > end_date
	 THEN RAISE bad_date;
	 END IF;
EXCEPTION
	 WHEN bad_date
				DBMS_OUTPUT.PUT_LINE('There cannot be taps in a date out of contract!');
END;
