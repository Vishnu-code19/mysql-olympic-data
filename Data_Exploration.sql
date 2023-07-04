-- select * from city ;
-- select * from competitor_event;
-- select * from event;
-- select * from games;
-- select * from games_city;
-- select * from games_competitor;
-- select * from medal;
-- select * from noc_region;
-- select * from person;
-- select * from person_region;
-- select * from sport;
								-- DATA EXPLORATION OF OLYMPICS SCHEMA -- 

-- who has won the most gold medals in the Olympics?
SELECT Most_Gold_Medal_Holder 
FROM (SELECT p.full_name Most_Gold_Medal_Holder, COUNT(ce.medal_id) 
FROM person p
JOIN games_competitor gc ON p.id = gc.person_id
JOIN competitor_event ce ON gc.id = ce.competitor_id
WHERE ce.medal_id = 1
GROUP BY p.full_name
ORDER BY 2 DESC) t
LIMIT 1; -- this limit can be removed to get the list

-- What is the most popular sport in the Olympics?
WITH cte AS (
SELECT e.sport_id,COUNT(gc.person_id)
FROM games_competitor gc 
LEFT JOIN competitor_event ce ON gc.id = ce.competitor_id
JOIN event e ON ce.event_id = e.id
GROUP BY e.sport_id
ORDER BY COUNT(gc.person_id) DESC)

SELECT sport_name AS Most_Popular_sport FROM cte
LEFT JOIN sport s ON s.id = cte.sport_id
LIMIT 1; -- this limit can be removed to get the list

-- What country has won the most medals in the Olympics?
WITH cte AS (
SELECT nr.region_name rn, COUNT(*) mdlcnt
FROM person p
JOIN games_competitor gc ON p.id = gc.person_id
JOIN competitor_event ce ON gc.id = ce.competitor_id
LEFT JOIN person_region pr ON pr.person_id = p.id
LEFT JOIN noc_region nr ON nr.id = pr.region_id
WHERE ce.medal_id <> 4
GROUP BY nr.region_name
ORDER BY mdlcnt DESC)
SELECT rn Top_Country 
FROM cte
LIMIT 1;

-- Number of medals Won by India for every year ordered in descending order
SELECT nr.region_name, games.games_year, COUNT(*) no_of_medals
FROM person
JOIN person_region pr ON person.id = pr.person_id
LEFT JOIN noc_region nr ON pr.region_id = nr.id
JOIN games_competitor gc ON person.id = gc.person_id
JOIN competitor_event ce ON gc.id=ce.competitor_id
LEFT JOIN games ON gc.games_id = games.id
WHERE ce.medal_id IS NOT NULL AND ce.medal_id<>4 
AND nr.region_name LIKE 'India'
GROUP BY nr.region_name, games.games_year
ORDER BY no_of_medals DESC;

-- Table giving info. related to specific MEDAL winner
WITH CTE AS (SELECT person.id,person.full_name,person.gender, person.height,person.weight,sport.sport_name,
(CASE WHEN ce.medal_id = 1 THEN 1 ELSE 0 END) AS gold_medal,
(CASE WHEN ce.medal_id = 2 THEN 1 ELSE 0 END) AS silver_medal,
(CASE WHEN ce.medal_id = 3 THEN 1 ELSE 0 END) AS bronze_medal
FROM person JOIN games_competitor gc ON person.id = gc.person_id
LEFT JOIN competitor_event ce ON gc.id = ce.competitor_id
LEFT JOIN event ON ce.event_id = event.id
LEFT JOIN sport ON event.sport_id = sport.id)

SELECT id,full_name,gender,height,weight,sport_name,
SUM(gold_medal) gold_medals, SUM(silver_medal) silver_medals, SUM(bronze_medal) bronze_medals FROM CTE
WHERE gold_medal<>0 OR silver_medal<>0 OR bronze_medal<>0
GROUP BY id,full_name,gender,height,weight,sport_name
order by sport_name, gold_medals desc, silver_medals desc, bronze_medals desc;

-- DATA CREDIT : www.databasestar.com
