DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
); 

SELECT *
FROM netflix;

SELECT count(*) as total_content
FROM netflix;

SELECT DISTINCT type
FROM netflix;

-- 15 Business Problems
-- 1. Count the Number of Movies vs TV Shows
SELECT type, count(*) total_by_type
FROM netflix
GROUP By type;

-- 2. Find the 3 Most Common Rating for Movies and TV Shows
WITH ranked_ratings as (SELECT type, 
		rating, 
		count(*) as rating_count,
		RANK() OVER(PARTITION BY type ORDER BY count(*) DESC ) as raking 
	FROM netflix
	GROUP BY type, rating
	ORDER BY rating_count DESC)

SELECT type,
	rating
FROM ranked_ratings
WHERE raking IN (1, 2,3)
ORDER BY type;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT *
FROM netflix
WHERE release_year =  2020 AND
	type = 'Movie';

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	UNNEST(string_to_array(country, ',')) as new_country, 
	count(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify title of the Longest Movie
SELECT 
	title, 
	split_part(duration, ' ', 1)::INT as duration_in_minutes
FROM netflix
WHERE split_part(duration, ' ', 1)::INT IS NOT NULL AND
	type = 'Movie'
ORDER BY 2 DESC
LIMIT 1;


-- 6. Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE to_date(date_added, 'Month DD,YYYY') >=  CURRENT_DATE - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
WITH director_split as (
	SELECT *,
		UNNEST(string_to_array(director, ',')) as director_name
	FROM netflix
)
SELECT * 
FROM director_split
WHERE director_name = 'Rajiv Chilaka';

-- 8. List All TV Shows with More Than 5 Seasons ordered by season
SELECT *
FROM 
	(SELECT 
		*,
		split_part(duration, ' ', 1)::INT as num_season
	 FROM netflix)
WHERE num_season > 5 AND
	type = 'TV Show'
ORDER BY num_season DESC;

-- 9. Count the Number of Content Items in Each Genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	count(*) as content_by_genre
FROM netflix
GROUP BY 1;

-- 10.Find each year and the numbers of content release in Brazil on netflix and return the total
WITH content_by_country as (
	SELECT *,
	 	UNNEST(string_to_array(country , ',')) as new_country
	FROM netflix)
	
SELECT release_year,
	count(*) as total_content_brazil
FROM content_by_country
WHERE new_country = 'Brazil'
GROUP BY GROUPING SETS (release_year, ())
ORDER BY release_year DESC NULLS LAST;

-- 11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE type = 'Movie' AND 
	listed_in LIKE '%Documentaries%';

-- 12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Timothée Chalamet' Appeared in the Last 8 Years
SELECT *
FROM netflix
WHERE to_tsvector(casts) @@ plainto_tsquery('Timothée Chalamet') AND
	to_date(date_added, 'Month DD,YYYY') >=  CURRENT_DATE - INTERVAL '8 years' ;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in USA
WITH content_actor_USA as (
	SELECT *,
		 UNNEST(string_to_array(casts , ',')) as actor
	FROM netflix
	WHERE type = 'Movie' AND
		to_tsvector(country) @@ plainto_tsquery('United States') )

SELECT actor,
	count(*) as movies_amount
FROM content_actor_USA
GROUP BY actor 
ORDER BY movies_amount DESC ;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT *
FROM netflix
WHERE description ILIKE '%kill%' or 
	description ILIKE '%violence%';
