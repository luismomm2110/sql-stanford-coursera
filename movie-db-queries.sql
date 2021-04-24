/* Find the titles of all movies directed by Steven Spielberg */
SELECT title
FROM Movie
WHERE director = "Steven Spielberg";

/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */ 
SELECT distinct M.year
FROM Movie as M, Rating as R
WHERE R.mID= M.mID and (R.stars = 4 or R.stars = 5)
ORDER BY M.year ASC;

/* Find the titles of all movies that have no ratings. */ 

SELECT distinct M.title
FROM Movie as M WHERE M.title NOT IN (SELECT M.title FROM Movie as M, Rating as R
WHERE M.mID = R.mID);

/* Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */

SELECT distinct R.name
FROM Reviewer as R, Rating as RT
WHERE R.rID = RT.rID and RT.ratingDate is NULL;

/*Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of star  */ 

SELECT R.Name, M.title, RT.stars, RT.ratingDate
FROM Movie as m, Reviewer as R, Rating as RT
WHERE M.mID = RT.mID and R.rID = RT.rID
ORDER BY R.name ASC, M.title ASC, RT.stars;

/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
 return the reviewer's name and the title of the movie. */ 

SELECT R.name, M.title
FROM Movie as M
INNER JOIN Rating as RT1 USING(mID)
INNER JOIN Rating as RT2 USING(rID)
INNER JOIN Reviewer as R USING (rID)
WHERE RT1.ratingDate < RT2.ratingDate and RT1.stars < RT2.stars and RT1.mID = RT2.mID;

 
/* For each movie that has at least one rating, find the highest number of stars that movie received.
 Return the movie title and number of stars. Sort by movie title. */ 

SELECT M.title, MAX(RT.stars) 
FROM Rating as RT
INNER JOIN Movie as M USING (mID)
GROUP BY RT.mID 
ORDER BY M.Title;

/* For each movie, return the title and the 'rating spread',that is, the difference between highest and lowest 
ratings given to that movie. Sort by rating spread from highest to lowest, then b */ 

SELECT M.title, (MAX(RT.stars) - MIN(RT.stars)) as 'rating spread'
FROM Rating as RT
INNER JOIN Movie as M USING (mID)
GROUP BY M.mID
ORDER BY (MAX(RT.stars) - MIN(RT.stars)) DESC, M.title;


/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.) */ 

SELECT AVG(b1980.avg) - AVG(a1980.avg)
FROM (
  SELECT AVG(stars) AS avg
  FROM Movie
  INNER JOIN Rating USING(mId)
  WHERE year < 1980
  GROUP BY mId
) AS b1980, (
  SELECT AVG(stars) AS avg
  FROM Movie
  INNER JOIN Rating USING(mId)
  WHERE year > 1980
  GROUP BY mId
) AS a1980;
