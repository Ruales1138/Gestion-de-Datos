-- 1 -----------------------------------------------------------

CREATE OR REPLACE VIEW v_countries_01 AS
SELECT 
    code AS id,
    name AS name,
    CASE 
        WHEN surface_area <= 1000000 THEN 'SMALL'
        WHEN surface_area <= 5000000 THEN 'MEDIUM'
        ELSE 'BIG'
    END AS relative_size
FROM world.countries;

SELECT * FROM v_countries_01;

-- 2 -----------------------------------------------------------

CREATE OR REPLACE VIEW v_countries_02 AS
SELECT 
    code AS id,
    name AS name,
    CASE 
        WHEN surface_area <= 1000000 THEN 'SMALL'
        WHEN surface_area <= 5000000 THEN 'MEDIUM'
        ELSE 'BIG'
    END AS relative_size
FROM world.countries
WHERE continent IN ('North America', 'South America');[cite: 2]

SELECT * FROM v_countries_02;

UPDATE world.countries 
SET surface_area = 500000.00 
WHERE code = 'COL';

SELECT * FROM v_countries_02 WHERE id = 'COL';

-- 3 -----------------------------------------------------------

CREATE OR REPLACE VIEW v_countries_03 AS
SELECT 
    code,
    name,
    continent,
    indep_year AS independence_year,
    -- Calcula la diferencia de años desde la independencia hasta el año actual
    FLOOR(YEAR(CURDATE()) - indep_year) AS years_since_independence
FROM world.countries;

SELECT * FROM v_countries_03 WHERE code = 'COL';

UPDATE world.countries 
SET indep_year = 1900 
WHERE code = 'COL';

SELECT * FROM v_countries_03 WHERE code = 'COL';

-- 4 -----------------------------------------------------------

CREATE OR REPLACE VIEW v_countries_04 AS
SELECT 
    c.id AS country_id,
    cl.language_id AS language_name,
    cl.is_official AS is_official
FROM world.countries c
LEFT JOIN world.countries_languages cl 
    ON c.id = cl.country_id;

SELECT * FROM v_countries_04;

-- 5 -----------------------------------------------------------

CREATE OR REPLACE VIEW v_cities_countries_01 AS
SELECT 
    co.id AS country_id,
    ci.id AS city_id,
    co.name AS country_name,
    ci.name AS city_name
FROM world.countries co
INNER JOIN world.cities ci 
    ON co.id = ci.country_id
ORDER BY 
    co.name ASC, 
    ci.name ASC;

SELECT * FROM v_cities_countries_01;