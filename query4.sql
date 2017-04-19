SELECT actor
FROM
(
(
SELECT  month_views, MAX(counter_titles) AS maximum
FROM (SELECT actor, TO_CHAR(view_datetime, 'MM-YYYY') AS month_views, COUNT(title) counter_titles
FROM (SELECT actor, view_datetime, title
FROM casts
NATURAL JOIN taps_movies)
GROUP BY actor, TO_CHAR(view_datetime, 'MM-YYYY')
ORDER BY counter_titles DESC)
GROUP BY month_views
ORDER BY month_views DESC)
first_join JOIN
(
SELECT actor, TO_CHAR(view_datetime, 'MM-YYYY') AS month_views, COUNT(title) counter_titles
FROM (SELECT actor, view_datetime, title
FROM casts
NATURAL JOIN taps_movies)
GROUP BY actor, TO_CHAR(view_datetime, 'MM-YYYY')
ORDER BY counter_titles DESC)
second_join
ON (maximum = counter_titles AND first_join.month_views = second_join.month_views)
)
ORDER BY TO_DATE(first_join.month_views, 'MM-YYYY');
