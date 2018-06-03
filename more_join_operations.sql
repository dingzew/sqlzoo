/* 1.List the films where the yr is 1962 [Show id, title] */
SELECT id, title
FROM movie
WHERE yr=1962

/* 2.Give year of 'Citizen Kane'. */
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

/* 3. List all of the Star Trek movies, include the id, title and yr 
(all of these movies include the words Star Trek in the title). Order results by year.*/
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr

/* 4. What id number does the actor 'Glenn Close' have?*/
SELECT id
FROM actor
WHERE name = 'Glenn Close'

/* 5. What is the id of the film 'Casablanca' */
SELECT id
FROM movie
WHERE title = 'Casablanca'

/* 6. Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question)*/
SELECT name
FROM casting JOIN actor ON actorid = id
WHERE movieid = 27

/* 7. Obtain the cast list for the film 'Alien'*/
SELECT name
FROM casting JOIN actor ON actorid = id
WHERE movieid =  (SELECT id FROM movie WHERE title = 'Alien')

/* 8. List the films in which 'Harrison Ford' has appeared */
SELECT title
FROM 
(SELECT movieid
FROM actor JOIN casting ON id = actorid
WHERE name = 'Harrison Ford') mvid JOIN movie ON (movieid = movie.id)


/* 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. 
[Note: the ord field of casting gives the position of the actor. 
If ord=1 then this actor is in the starring role]*/
SELECT title
FROM 
(SELECT movieid
FROM actor JOIN casting ON id = actorid
WHERE name = 'Harrison Ford' AND ord <> 1) mvid JOIN movie ON (movieid = movie.id)

/* 10. List the films together with the leading star for all 1962 films.*/
SELECT title, name FROM
	((SELECT name, movieid
	FROM actor JOIN casting ON actorid = id
	WHERE ord = 1) star JOIN movie ON movieid = id)
WHERE yr = 1962

/* 11. Which were the busiest years for 'John Travolta', 
show the year and the number of movies he made each year 
for any year in which he made more than 2 movies.*/
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)

/* 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */
SELECT title, name
FROM
	(SELECT movieid, name
	FROM
		(SELECT casting.movieid, actorid 
		FROM
			(SELECT movieid 
			FROM casting
			WHERE actorid IN (
			SELECT id FROM actor
			WHERE name='Julie Andrews')) targetMovie JOIN casting ON casting.movieid = targetMovie.movieid
		WHERE ord = 1) targetActor JOIN actor ON id = actorid) targetResult JOIN movie ON movieid = include
ORDER BY name DESC

/* 13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.*/
SELECT name
FROM
	(SELECT name, COUNT(*) as times
	FROM actor JOIN casting ON id = actorid
	GROUP BY id, name) res
WHERE res.times >= 30


/* 14. List the films released in the year 1978 ordered 
by the number of actors in the cast, then by title.*/
SELECT title, COUNT(*)
FROM
(SELECT * FROM movie
WHERE yr = 1978) targetMovie JOIN casting ON id = movieid
GROUP BY title
ORDER BY COUNT(*) DESC, title

/* 15. List all the people who have worked with 'Art Garfunkel'.*/
SELECT name
FROM
	(SELECT casting.actorid
	FROM
		(SELECT movieid, name, actorid  FROM
		casting JOIN actor ON id = actorid
		WHERE name =  'Art Garfunkel') targetMovie JOIN casting ON targetMovie.movieid  = casting.movieid
	WHERE casting.actorid <> 2064) resid JOIN actor ON actorid = id
ORDER BY name



