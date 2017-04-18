CREATE  OR REPLACE TRIGGER non_valid_tap_movies BEFORE INSERT OR UPDATE ON taps_movies
FOR EACH ROW
	DECLARE
		end_date taps_movies.enddate%TYPE;
		start_date taps_movies.startdate%TYPE;
	BEGIN
		end_date :=
		SELECT enddate
		FROM (SELECT enddate
		FROM contracts
		JOIN taps_movies ON (CONTRACTS.contractId = TAPS_MOVIES.contractId))
		WHERE :NEW.view_datetime = view_datetime; --AND enddate IS NOT NULL
		start_date :=
		SELECT startdate
		FROM (SELECT startdate
		FROM contracts
		JOIN taps_movies ON (CONTRACTS.contractId = TAPS_MOVIES.contractId))
		WHERE :NEW.view_datetime = view_datetime;
	IF (c1 IS NOT NULL) AND ((:NEW.view_datetime > c1) OR (:NEW.view_datetime < c2))
	THEN RAISE RAISE_APPLICATION_ERROR (-20001, 'There cannot be taps in a date out of contract!');
	END IF;
END non_valid_tap_movies;
/
