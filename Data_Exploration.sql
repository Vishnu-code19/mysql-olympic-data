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

-- 1. who has won the most gold medals in the Olympics?
SELECT Most_Gold_Medal_Holder 
FROM (SELECT p.full_name Most_Gold_Medal_Holder, COUNT(ce.medal_id) 
FROM person p
JOIN games_competitor gc ON p.id = gc.person_id
JOIN competitor_event ce ON gc.id = ce.competitor_id
WHERE ce.medal_id = 1
GROUP BY p.full_name
ORDER BY 2 DESC) t
LIMIT 1;

-- 2. What is the most popular sport in the Olympics?
WITH cte AS (
SELECT e.sport_id,COUNT(gc.person_id)
FROM games_competitor gc 
LEFT JOIN competitor_event ce ON gc.id = ce.competitor_id
JOIN event e ON ce.event_id = e.id
GROUP BY e.sport_id
ORDER BY COUNT(gc.person_id) DESC)

SELECT sport_name AS Most_Popular_sport FROM cte
LEFT JOIN sport s ON s.id = cte.sport_id
LIMIT 1;

-- 3. What country has won the most medals in the Olympics?
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

-- DATA CREDIT : www.databasestar.com