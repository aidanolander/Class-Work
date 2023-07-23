USE assignment1;
-- Q1. Find the titles of all movies directed by Steven Spielberg.
SELECT title FROM Movie
WHERE director = 'Steven Spielberg';
#ET and Raiders of the Lost Ark


-- Q2. Find the movies names that contain the word "THE"
SELECT title FROM Movie
WHERE Movie.title LIKE '%the%';
#Gone with the wind, the sound of music, raiders of the lost ark



-- Q3. Find those rating records higher than 3 stars before 2011/1/15 or after 2011/1/20 
SELECT * FROM Rating
WHERE ratingDate>'2011/1/20' OR ratingDate<'2011/1/15'
HAVING stars>3;
#ratings 2011-01-27 and 2011-01-12
    
/* Q4. Some reviewers did rating on the same movie more than once. 
How many rating records are there with different movie and different reviewer's rating? */
SELECT Reviewer.name, Movie.title, COUNT(Reviewer.name)
FROM Reviewer INNER JOIN Rating 
ON Reviewer.rID = Rating.rID
INNER JOIN Movie 
ON Movie.mID = Rating.mID
GROUP BY Reviewer.name, Movie.title;



-- Q5. Which are the top 3 records with the highest ratings?
SELECT * FROM Rating
ORDER BY stars DESC
LIMIT 3;

-- Q6. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT Movie.year
FROM Movie INNER JOIN Rating 
ON Movie.mID = Rating.mID
WHERE Rating.stars>3
ORDER BY year;


-- Q7. Find the titles of all movies that have no ratings.
SELECT title FROM Movie LEFT JOIN Rating
ON Movie.mID=Rating.mID
WHERE rID IS NULL;


/* Q8. Some reviewers didn't provide a date with their rating. 
 Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT name FROM Reviewer LEFT JOIN Rating
ON Reviewer.rID=Rating.rID
WHERE ratingDate IS NULL;

 
/* Q9. Write a query to return the ratings data in a more readable format in only one field(column): 
"reviewer name, movie title, stars, ratingDate". 
Assign a new name to the new column as "Review_details"
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
Hint: join three tables, using join twice. 
Hint: use CONCAT_WS(separator, string1, string2) instead of CONCAT() for creating new column because of NULL values */
SELECT CONCAT_WS(' : ', name, title, stars, ratingDate) AS Review_details
FROM Rating INNER JOIN Reviewer
ON Rating.rID=Reviewer.rID
INNER JOIN Movie
ON Rating.mID=Movie.mID
ORDER BY name, title, stars;



 

 