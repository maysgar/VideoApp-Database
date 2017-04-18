CREATE VIEW pidgeonholed AS
SELECT FIRST_UNION.actor, genre, FIRST_UNION.maximum
FROM (SELECT MAX(num) as maximum, actor
FROM (SELECT genre, actor, COUNT(movie_title) AS num
FROM movies
JOIN casts ON MOVIES.movie_title = CASTS.title
JOIN genres_movies ON MOVIES.movie_title = GENRES_MOVIES.title
GROUP BY genre, actor HAVING COUNT(movie_title) >= 3)
GROUP BY actor) FIRST_UNION
JOIN
(SELECT genre, actor, COUNT(movie_title) AS num
FROM movies
JOIN casts ON MOVIES.movie_title=CASTS.title
JOIN genres_movies ON MOVIES.movie_title=GENRES_MOVIES.title
GROUP BY genre, actor HAVING COUNT(movie_title) >= 3)
SECOND_UNION ON FIRST_UNION.maximum = SECOND_UNION.num AND FIRST_UNION.actor = SECOND_UNION.actor
WHERE maximum >= (SELECT COUNT(title)/2 FROM casts GROUP BY actor HAVING actor = FIRST_UNION.actor)
ORDER BY maximum DESC;
