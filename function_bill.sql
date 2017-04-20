CREATE OR REPLACE FUNCTION function_bill (input_client VARCHAR2, input_month VARCHAR2, input_product VARCHAR2) RETURN NUMBER
IS
		total_cost NUMBER;
		zapping NUMBER;
		cost_movies NUMBER;
		cost_series NUMBER;
CURSOR pay_movies(input_client VARCHAR2, input_month VARCHAR2, input_product VARCHAR2) IS
		SELECT clientId,contractId, duration, product_name,tap_costMovies,month, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId,contractId,title1, product_name,tap_cost as tap_costMovies,month, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId, contractId,title1, contract_type, month, pct FROM(
		SELECT title AS title1, contractId, to_char(view_datetime, 'MM-YYYY') AS month, pct
		FROM taps_movies)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type WHERE (product_name= input_product AND month = input_month AND clientId = input_client)) JOIN movies ON title1=movie_title;
CURSOR pay_series(input_client VARCHAR2, input_month VARCHAR2, input_product VARCHAR2) IS
		SELECT clientId,contractId, product_name,tap_cost as tap_costSeries,month,type, zapp, ppm, ppd, promo FROM(
		SELECT clientId, contractId, contract_type, month FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MM-YYYY') AS month
		FROM taps_series)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type
		WHERE product_name= input_product AND month = input_month AND clientId = input_client;
BEGIN
		IF pay_movies %ISOPEN THEN
				CLOSE pay_movies;
			END IF;
		CASE input_product
				WHEN 'Free Rider' THEN  total_cost := 10;
				WHEN 'Premium Rider' THEN total_cost := 39;
				WHEN 'TVrider' THEN total_cost := 29;
				WHEN 'Flat Rate Lover' THEN total_cost := 39;
				WHEN 'Short Timer' THEN total_cost := 15;
				WHEN 'Content Master' THEN total_cost := 20;
				WHEN 'Boredom Fighter' THEN total_cost := 10;
				WHEN 'Low Cost Rate' THEN total_cost := 0;
		END CASE;
		cost_movies := 0;
		FOR clientId IN pay_movies(input_client, input_month, input_product)
		LOOP
			zapping := 1;
			IF clientId.zapp > clientId.pct THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
					END IF;
					IF clientId.type = 'C' THEN
									clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
					END IF;
			cost_movies := clientId.tap_costMovies + cost_movies;
		END LOOP;
		cost_movies := cost_movies * 2;
		cost_series := 0;
		IF pay_series %ISOPEN THEN
				CLOSE pay_series;
			END IF;
		FOR clientId IN pay_series(input_client, input_month, input_product)
		LOOP
			cost_series := clientId.tap_costSeries + cost_series;
		END LOOP;
		total_cost := cost_series + cost_movies + total_cost;
		DBMS_OUTPUT.PUT_LINE(total_cost || '$');
		RETURN total_cost;
END;
/
