--d) Top-Star: actor/actress who had got more taps (summing up all the taps of his/her movies) for each
--month (should retrieve a row for each month since the database is on duty). 


CREATE VIEW primeroo AS 
SELECT actor, view_datetime, title
FROM casts
NATURAL JOIN taps_movies;

CREATE VIEW segundoo AS
SELECT actor, TO_CHAR(view_datetime, 'MM-YYYY') AS month_views, COUNT(title) counter_titles
FROM primeroo
GROUP BY actor, TO_CHAR(view_datetime, 'MM-YYYY')
ORDER BY TO_CHAR(view_datetime, 'MM-YYYY') DESC;

CREATE VIEW terceroo AS
SELECT actor, month_views, MAX(counter_titles) AS maximum
FROM segundoo
GROUP BY actor, month_views;

CREATE VIEW cuartoo AS
SELECT actor, maximum, month_views
FROM terceroo
GROUP BY actor, maximum, month_views;


CREATE VIEW quinto AS
SELECT actor
FROM cuarto


CREATE VIEW cuartoo AS
SELECT actor, month_views, maximum
FROM (SELECT actor, month_views, MAX(counter_titles) AS maximum
FROM (SELECT actor, TO_CHAR(view_datetime, 'MM-YYYY') AS month_views, COUNT(title) counter_titles
FROM (SELECT actor, view_datetime, title
FROM casts
NATURAL JOIN taps_movies)
GROUP BY actor, TO_CHAR(view_datetime, 'MM-YYYY')
ORDER BY TO_CHAR(view_datetime, 'MM-YYYY') DESC)
GROUP BY month_views)
GROUP BY actor, month_views;
