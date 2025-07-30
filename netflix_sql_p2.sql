-- Netflix Project
-- Sparsh Shukla

CREATE TABLE netflix
 (  show_id	VARCHAR(10) , -- as as it has both numericals and charcaters
    type  VARCHAR(15) ,	
	title 	VARCHAR(150),
	director VARCHAR(250),	
	casts  	VARCHAR(1000),
	country	VARCHAR(200),
	date_added	VARCHAR(25),
	release_year INT,	
	rating	VARCHAR(15),
	duration VARCHAR(15),
	listed_in	VARCHAR(150),
	description VARCHAR(300)
);

----------------------------------------------------------------------------------------------
-- DATA EXPLORATION 
----------------------------------------------------------------------------------------------

-- Displaying the Table

SELECT * FROM netflix;

-- Finding the total rows 

SELECT 
COUNT(*) AS total_count
FROM netflix;

-- Finding distinct value of rating_types

SELECT 
DISTINCT rating as rating_types
FROM netflix;

-- Finding Null values for director
SELECT 
COUNT(*) AS null_values
FROM netflix
WHERE director ISNULL;


----------------------------------------------------------------------------------------------
-- Solving 30 business problems
----------------------------------------------------------------------------------------------
-- 30 Business Problems & Solutions
-- 1. Count the number of content items grouped by type (Movies vs TV Shows)
-- 2. Find the most common rating for each type (Movie or TV Show)
-- 3. Select all Movies released in the year 2020
-- 4. Find the top 5 countries with the highest number of content items
-- 5. Identify the Movie with the maximum duration
-- 6. Retrieve all content added in the last 5 years
-- 7. Find all content where the cast includes 'Aamir Khan'
-- 8. List all TV Shows that have more than 5 seasons
-- 9. Count total content grouped by each genre
-- 10. Find the top 5 years with the highest number of Indian content releases
-- 11. Select all Movies that belong to the 'Documentaries' genre
-- 12. Retrieve all content with no listed director
-- 13. Find Movies with 'Salman Khan' released in the last 10 years
-- 14. Identify the top 10 actors in Indian Movies by number of appearances
-- 15. Categorize content as 'Bad' if description includes 'kill' or 'violence', else 'Good'
-- 16. Find the weekday with the highest number of content additions
-- 17. List top 5 directors by number of content items
-- 18. Calculate average duration (in minutes) of Movies by genre
-- 19. Identify actors who have appeared in both Movies and TV Shows
-- 20. Calculate the percentage of content available from USA, India, and UK
-- 21. Determine the most common release month (based on date_added)
-- 22. Select all content where description contains the word 'love'
-- 23. Find the shortest Movie by duration
-- 24. Count how many content items were added each year since 2000
-- 25. List all content with more than one genre assigned
-- 26. Compute the average gap (in years) between release year and Netflix addition date for Movies
-- 27. Compare the most common genres between Movies and TV Shows
-- 28. Identify the top 5 most frequent words used in content descriptions
-- 29. List countries with content spanning more than 10 distinct genres
-- 30. Select all content with co-directors (i.e., more than one director listed)

----------------------------------------------------------------------------------------------
-- SOLUTIONS
----------------------------------------------------------------------------------------------

-- 1. Count the number of Movies vs TV Shows

  SELECT DISTINCT type , 
  COUNT(*) AS count
  FROM netflix
  GROUP BY 1
  ORDER BY 1
  
-- 2. Find the most common rating for movies and TV shows
      
	SELECT DISTINCT ON (type) 
	    type, COUNT(*) AS count , rating
	   FROM netflix
	   GROUP BY 1 ,3
       ORDER BY 1  , count DESC

	   
-- 3. List all movies released in a specific year (e.g., 2020)

       SELECT *
        FROM netflix
		WHERE release_year = 2020 AND type = 'Movie'
		

-- 4. Find the top 5 countries with the most content on Netflix
-- TIP - here splitting is good approach

SELECT country_clean AS highest_content_countries , count(*) as total_contributions
FROM ( SELECT unnest(string_to_array(country, ', ')) AS country_clean 
       FROM netflix
       WHERE country IS NOT NULL ) AS split_countries 
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5 ;

 
-- 5. Identify the longest movie

SELECT * 
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration ,' ', 1) AS INTEGER) DESC

-- 6. Find content added in the last 5 years

SELECT * 
FROM netflix 
WHERE date_added IS NOT NULL
AND TO_DATE(date_added , 'Month DD ,YYYY' ) >= (CURRENT_DATE - INTERVAL '5years ' )
ORDER BY TO_DATE(date_added , 'Month DD ,YYYY' ) DESC


-- 7. Find all the movies/TV shows featuring actor 'Aamir Khan'.
-- TIP - ILIKE IS used for case-sensitive searching

SELECT * 
FROM netflix 
WHERE casts ILIKE '%Aamir Khan%'

-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE type = 'TV Show' 
AND duration IS NOT NULL
AND CAST(SPLIT_PART(duration , ' ', 1) AS INTEGER) > 5 
ORDER BY CAST(SPLIT_PART(duration , ' ', 1) AS INTEGER) DESC



-- 9. Count the number of content items in each genre
SELECT genre, COUNT(*) AS total_content_by_genre
FROM (
    SELECT unnest(string_to_array(listed_in, ', ')) AS genre
    FROM netflix
    WHERE listed_in IS NOT NULL
) AS genre_split
GROUP BY genre
ORDER BY total_content_by_genre DESC;

-- 10. Find each year and the average numbers of content release in India on Netflix. 
--     Return top 5 years with highest avg content release!
  SELECT  release_year , COUNT(release_year) AS total_occurance
  FROM netflix 
  WHERE country ILIKE '%India%' 
  AND date_added IS NOT NULL
  GROUP BY release_year 
  ORDER BY total_occurance DESC
  LIMIT 5 ;  


-- 11. List all movies that are documentaries

SELECT  *
FROM netflix
WHERE type ILIKE '%Movie%'
AND listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT * 
FROM netflix
WHERE director ISNULL ;



-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * 
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10 ;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT actors , COUNT(*) AS movie_count
FROM 
(
SELECT unnest(string_to_array(casts , ',')) AS actors
FROM netflix
WHERE type ILIKE '%Movie%'
AND casts IS NOT NULL
AND country ILIKE '%INDIA%'
) AS actor_list
GROUP BY actors
ORDER BY movie_count DESC
LIMIT 10;


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--     the description field. Label content containing these keywords as 'Bad' and all other 
--     content as 'Good'. Count how many items fall into each category

SELECT 
CASE
WHEN description ILIKE '%kill%' 
OR description ILIKE '%violence%' 
THEN 'Bad'
ELSE 'Good'
END AS Category , COUNT(*) as total_items
FROM netflix
WHERE description IS NOT NULL
GROUP BY Category
ORDER BY total_items DESC;




-- 16. Which day of the week is content most often added on Netflix?


SELECT TO_CHAR(TO_DATE(date_added,'Month DD, YYYY'), 'Day') AS days_of_the_week ,COUNT(*) as total_days
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY days_of_the_week
ORDER BY total_days DESC;


-- 17. List the top 5 directors with the highest number of content items on Netflix.

SELECT  DISTINCT list_of_directors , COUNT(*) AS highest_number_of_content
FROM
(SELECT unnest(string_to_array(director,',')) 
 FROM netflix
 WHERE director IS NOT NULL) AS list_of_directors
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5;



-- 18. Find the average duration of movies for each genre.

SELECT  genre  , AVG(duration_mintues) as average_duration
FROM
(SELECT unnest(string_to_array(listed_in,', ')) AS genre, 
CAST(SPLIT_PART(duration,' ',1) AS INTEGER) AS duration_mintues
FROM netflix
WHERE type ILIKE '%Movie%'
AND listed_in IS NOT NULL 
AND type IS NOT NULL) AS genre_table
GROUP BY 1
ORDER BY 2 DESC


-- 19. Which actors have appeared in both Movies and TV Shows?

SELECT actors 
FROM
(SELECT TRIM(UNNEST(string_to_array(casts,', '))) AS actors , type as media
FROM netflix
WHERE casts IS NOT NULL ) AS actor_list
GROUP BY actors
HAVING COUNT(DISTINCT media) = 2
ORDER BY 1


-- 20. What percentage of content is available from the USA, India, and the UK?
WITH countries_table AS (
    SELECT UNNEST(string_to_array(country, ', ')) AS countries
    FROM netflix
    WHERE country IS NOT NULL
),
total_count AS (
    SELECT COUNT(*) AS total FROM countries_table
)
SELECT 
    countries,
    COUNT(*) AS contribution,
    ROUND(100.0 * COUNT(*) / total_count.total, 2) AS percentage
FROM countries_table, total_count
WHERE countries IN ('India', 'United States', 'United Kingdom')
GROUP BY countries, total_count.total
ORDER BY contribution DESC;


-- 21. Find the most common release month for Netflix content.
SELECT TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS release_month,
       COUNT(*) AS count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY 1
ORDER BY count DESC;

-- 22. Identify all content that includes the word ‘love’ in the description.

SELECT *
FROM netflix
WHERE description ILIKE '%love%';

-- 23. Find the shortest movie on Netflix.
SELECT *
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) ASC
LIMIT 1;

-- 24. Count how many content items were added each year since 2000.
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
       COUNT(*) AS total_added
FROM netflix
WHERE date_added IS NOT NULL AND EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) >= 2000
GROUP BY 1
ORDER BY year_added;

-- 25. List all content tagged with multiple genres (more than 1 genre).
SELECT *
FROM netflix
WHERE listed_in LIKE '%,%';

-- 26. Find the average time gap between a movie’s release year and its addition to Netflix.
SELECT ROUND(AVG(EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) - release_year), 2) AS avg_gap_years
FROM netflix
WHERE date_added IS NOT NULL AND release_year IS NOT NULL AND type = 'Movie';

-- 27. Which genres are most common in TV Shows vs Movies?
SELECT type, genre, COUNT(*) AS count
FROM (
    SELECT type, UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix
    WHERE listed_in IS NOT NULL
) AS genre_split
GROUP BY 1, 2
ORDER BY type, count DESC;

-- 28. List the top 5 most common words used in content descriptions.

SELECT word, COUNT(*) AS frequency
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(LOWER(REGEXP_REPLACE(description, '[^a-zA-Z ]', '', 'g')), ' ')) AS word
    FROM netflix
    WHERE description IS NOT NULL
) AS words
WHERE LENGTH(word) > 3
GROUP BY word
ORDER BY frequency DESC
LIMIT 5;

-- 29. Which countries have produced Netflix content in more than 10 genres?

SELECT countries, COUNT(DISTINCT genre) AS genre_count
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ', ')) AS countries,
           UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix
    WHERE country IS NOT NULL AND listed_in IS NOT NULL
) AS genre_country
GROUP BY countries
HAVING COUNT(DISTINCT genre) > 10
ORDER BY genre_count DESC;

-- 30. Identify all movies or shows that have been co-directed (i.e., more than one director listed).

SELECT *
FROM netflix
WHERE director LIKE '%,%';




