--b) Prevent non-valid visualizations regarding contracts (there cannot be taps in a date out of
--contract). 
-- 2 triggers: one for movies and one for series

CREATE TRIGGER non_valid_tap_movies
BEFORE INSERT OR UPDATE ON taps_movies
FOR EACH ROW
DECLARE
end_date DATE; --cursores
start_date DATE;
bad_date EXCEPTION;
BEGIN
SELECT enddate INTO end_date
FROM contracts;   -- from(querie) seleccionando startdate, enddate y haciendo join de contracts y taps_movies
SELECT startdate INTO start_date
FROM contracts;
IF (:NEW.view_datetime > end_date) OR (:NEW.view_datetime < start_date)
THEN RAISE bad_date;
END IF;
EXCEPTION
WHEN bad_date THEN
DBMS_OUTPUT.PUT_LINE('There cannot be taps in a date out of contract!');
END;
/



CREATE TRIGGER non_valid_tap_series
BEFORE INSERT OR UPDATE ON taps_series
FOR EACH ROW
DECLARE end_date DATE;
	start_date DATE;
        bad_date EXCEPTION;
BEGIN
	SELECT enddate INTO end_date FROM contracts;
	SELECT startdate INTO start_date FROM contracts;
	IF (:NEW.view_datetime > end_date) OR (:NEW.view_datetime < start_date)
	THEN RAISE bad_date;
	END IF;
EXCEPTION
	 WHEN bad_date THEN
	 DBMS_OUTPUT.PUT_LINE('There cannot be taps in a date out of contract!');
END;
/
