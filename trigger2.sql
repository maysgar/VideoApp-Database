CREATE OR REPLACE TRIGGER non_valid_tap_movies BEFORE INSERT ON taps_movies
FOR EACH ROW
	DECLARE
		myContract contracts%ROWTYPE;
	BEGIN
		SELECT * INTO myContract
			FROM contracts
			WHERE contractId = :NEW.contractId	AND enddate IS NOT NULL;
		IF (TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') > myContract.enddate OR TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') < myContract.startdate OR TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') > sysdate)
		 THEN RAISE_APPLICATION_ERROR (-20001, 'There cannot be taps in a date out of contract!');
	    END IF;
END non_valid_tap_movies;
/

CREATE OR REPLACE TRIGGER non_valid_tap_series BEFORE INSERT ON taps_series
FOR EACH ROW
	DECLARE
		myContract contracts%ROWTYPE;
	BEGIN
		SELECT * INTO myContract
			FROM contracts
			WHERE contractId = :NEW.contractId	AND enddate IS NOT NULL;
		IF (TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') > myContract.enddate OR TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') < myContract.startdate OR TO_DATE(:NEW.view_datetime, 'DD-MM-YYYY') > sysdate)
		 THEN RAISE_APPLICATION_ERROR (-20001, 'There cannot be taps in a date out of contract!');
	    END IF;
END non_valid_tap_series;
/
