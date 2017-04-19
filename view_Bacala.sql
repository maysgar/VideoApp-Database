CREATE VIEW Bacala AS
SELECT title
FROM(SELECT title, COUNT(pct) AS num
FROM (SELECT title, pct
FROM taps_movies
WHERE (pct > 50) AND (pct < 97)
GROUP BY title, pct)
GROUP BY title
ORDER BY num DESC)
WHERE ROWNUM <= 5
ORDER BY num, title;
