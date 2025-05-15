Q--.1.
--Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;


--Q.2. 
--Find the Most Common Rating for Movies and TV Shows
SELECT 
        type,
        rating AS most_frequent_rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank
FROM netflix
GROUP BY 1,2

--Q.3.
--List All Movies Released in a 2021
SELECT * 
FROM netflix
WHERE release_year = 2021;



--Q.4.
--Find the Top 5 Countries with the Most Content on Netflix
SELECT * 
FROM
(
    SELECT 
        TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5
;


--Q.5.
--Identify the Longest Movie
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
      AND duration IS NOT NULL 
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;




--Q.6.
--Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';



--Q.7.
--Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';


--Q.8
--List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


--Q.9. 
--Count the Number of Content Items in Each Genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;



--Q.10
--Find each year and the average numbers of content release in France on netflix
--return top 5 year with highest avg content release
SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
		COUNT(*) as yearly_content,
		ROUND	
		(COUNT(*)::numeric/
		(SELECT COUNT(*) FROM netflix  WHERE country = 'France')::numeric * 100 ,2) as avg_content
        --TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country
	
 FROM netflix
 WHERE country = 'France'
 GROUP BY 1
 ORDER BY 2 DESC



 --Q.11
 -- List All Movies that are Documentaries 
SELECT *
 FROM netflix
 WHERE listed_in LIKE '%Documentaries'



-- Q.12
--Find All Content Without a Director
SELECT *
FROM netflix
WHERE director IS NULL



--Q.13
--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
 AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10



 --Q.14
 --Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in France
 SELECT
 UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
 COUNT(*) AS total_content
 FROM netflix
 WHERE country ILIKE '%France%'
 GROUP BY 1
 ORDER BY 2 DESC



 --Q.15
 -- Categorize Content Based on the Presence of 'Kill' and 'Violence' 
 --Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise
 --Count the number of items in each category.
 With contentbased as
	 (SELECT *,
	       CASE 
		   WHEN  description ILIKE '%kill%' OR
	             description ILIKE '%Violence%' THEN 'Bad Content'
		         ELSE 'Good Content'	 
		   END category
	 FROM netflix)

 SELECT category,
       COUNT(*)
FROM contentbased
GROUP BY 1