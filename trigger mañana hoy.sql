--b) Prevent non-valid visualizations regarding contracts (there cannot be taps in a date out of
--contract). 
-- 2 triggers: one for movies and one for series

CREATE  OR REPLACE TRIGGER non_valid_tap_movies BEFORE INSERT ON taps_movies
FOR EACH ROW
	DECLARE
		end_date taps_movies.enddate%TYPE;
		start_date taps_movies.startdate%TYPE;
	BEGIN
		SELECT enddate INTO end_date
			FROM (SELECT enddate
			FROM contracts
			JOIN taps_movies ON (CONTRACTS.contractId = TAPS_MOVIES.contractId))
			WHERE (:NEW.view_datetime = view_datetime) AND (enddate IS NOT NULL);
		SELECT startdate INTO start_date
			FROM (SELECT startdate
			FROM contracts
			JOIN taps_movies ON (CONTRACTS.contractId = TAPS_MOVIES.contractId))
			WHERE :NEW.view_datetime = view_datetime;
	IF (:NEW.view_datetime > end_date) OR (:NEW.view_datetime < start_date)
		THEN RAISE RAISE_APPLICATION_ERROR (-20001, 'There cannot be taps in a date out of contract!');
	END IF;
END non_valid_tap_movies;
/
