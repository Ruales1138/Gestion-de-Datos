-- 1 -----------------------------------------------------------

SELECT * FROM countries;

DROP FUNCTION if EXISTS fn_get_country_attribute_by_id;

delimiter $$
CREATE FUNCTION fn_get_country_attribute_by_id(
	p_country_id TYPE OF countries.id, 
	p_attribute VARCHAR(100)
)
RETURNS VARCHAR(100)
BEGIN 
	DECLARE v_result VARCHAR(100) DEFAULT NULL;
	if LOWER(p_attribute) = 'name' then 
		SELECT name INTO v_result
		FROM countries
		WHERE id = p_country_id;
	ELSEIF LOWER(p_attribute) = 'continent' then
		SELECT continent INTO v_result
		FROM countries
		WHERE id = p_country_id;
	END if;
	RETURN v_result;
END;
$$
delimiter ;

SELECT fn_get_country_attribute_by_id('COL', 'name');
SELECT fn_get_country_attribute_by_id('COL', 'continent');

-- 2 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_get_cities_by_country_name;

delimiter $$
CREATE FUNCTION fn_get_cities_by_country_name(
	p_country_name TYPE OF countries.`name`
)
RETURNS text
DETERMINISTIC
BEGIN
	DECLARE v_country_id TYPE OF countries.id DEFAULT NULL;
	DECLARE v_city_name TYPE OF cities.`name` DEFAULT NULL;
	DECLARE v_cities_list TEXT DEFAULT '';
	DECLARE v_done BOOLEAN DEFAULT FALSE;
	
	DECLARE c_country CURSOR FOR
		SELECT id
		FROM countries
		WHERE `name` = p_country_name;
		
	DECLARE c_cities CURSOR FOR
		SELECT `name`
		FROM cities
		WHERE country_id = v_country_id;
		
	DECLARE CONTINUE handler FOR NOT found
		SET v_done = TRUE;
		
	OPEN c_country;
	fetch c_country INTO v_country_id;
	close c_country;
	
	if v_country_id IS NULL then
		RETURN NULL;
	END if;
	
	OPEN c_cities;
	loop_cities: loop 
		fetch c_cities INTO v_city_name;
		if v_done then
			leave loop_cities;
		END if;
		if v_cities_list = '' then
			set v_cities_list := v_city_name;
		ELSE 
			SET v_cities_list := CONCAT(v_cities_list, ', ', v_city_name);
		END if;
	END loop;
	close c_cities;
	
	RETURN v_cities_list;
END
$$
delimiter ;

SELECT fn_get_cities_by_country_name('Colombia');

-- 3 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_get_languages_by_country_name;

delimiter $$
CREATE FUNCTION fn_get_languages_by_country_name(
	p_country_name TYPE OF countries.`name`
)
RETURNS TEXT
DETERMINISTIC
BEGIN
	DECLARE v_country_id TYPE OF countries.id;
	DECLARE v_languague_name TYPE OF countries_languages.language_id;
	DECLARE v_all_languages TEXT DEFAULT '';
	DECLARE v_done BOOLEAN DEFAULT FALSE;
	
	DECLARE c_county CURSOR FOR 
		SELECT id
		FROM countries
		WHERE `name` = p_country_name;
		
	DECLARE c_languages CURSOR FOR 
		SELECT language_id
		FROM countries_languages
		WHERE country_id = v_country_id;
		
	DECLARE CONTINUE handler FOR NOT FOUND 
		SET v_done = TRUE;
		
	OPEN c_county;
	fetch c_county INTO v_country_id;
	close c_county;
	
	OPEN c_languages;
	loop_languages: loop
		fetch c_languages INTO v_languague_name;
		if v_all_languages = '' then
			SET v_all_languages = v_languague_name;
		END if;
		SET v_all_languages := CONCAT(v_all_languages, ', ', v_languague_name);
		if v_done then
			leave loop_languages;
		END if;
	END loop;
	close c_languages;
	
	RETURN v_all_languages;
END
$$
delimiter ;

SELECT fn_get_languages_by_country_name('Colombia');

-- 4 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_get_main_language_by_country_name;

delimiter $$
CREATE FUNCTION fn_get_main_language_by_country_name(
	p_country_name TYPE OF countries.`name`
)
RETURNS TYPE OF countries_languages.language_id
DETERMINISTIC
BEGIN
	DECLARE v_country_id TYPE OF countries.id;
	DECLARE v_language_name TYPE OF countries_languages.language_id DEFAULT NULL;
	DECLARE v_language_percentage TYPE OF countries_languages.percentage DEFAULT NULL;
	DECLARE v_main_language TYPE OF countries_languages.language_id DEFAULT NULL;
	DECLARE v_max FLOAT DEFAULT 0;
	DECLARE v_done BOOLEAN DEFAULT FALSE;
	
	DECLARE c_county CURSOR FOR 
		SELECT id
		FROM countries
		WHERE `name` = p_country_name;
		
	DECLARE c_languages CURSOR FOR 
		SELECT language_id, percentage
		FROM countries_languages
		WHERE country_id = v_country_id;
		
	DECLARE CONTINUE handler FOR NOT FOUND 
		SET v_done = TRUE;
		
	OPEN c_county;
	fetch c_county INTO v_country_id;
	close c_county;
	
	OPEN c_languages;
	loop_languages: loop
		fetch c_languages INTO v_language_name, v_language_percentage;
		if v_language_percentage > v_max then
			SET v_max := v_language_percentage;
			SET v_main_language := v_language_name;
		END if;
		if v_done then
			leave loop_languages;
		END if;
	END loop;
	close c_languages;
	
	RETURN v_main_language;
END
$$
delimiter ;

SELECT fn_get_main_language_by_country_name('Colombia');

-- 5 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_get_country_name_by_city_name;

delimiter $$
CREATE FUNCTION fn_get_country_name_by_city_name(
	p_city_name TYPE OF cities.`name`
)
RETURNS TYPE OF countries.`name`
DETERMINISTIC
BEGIN
	DECLARE v_country_id TYPE OF countries.id DEFAULT NULL;
	
	DECLARE c_country CURSOR FOR
		SELECT country_id
		FROM cities
		WHERE `name` = p_city_name;
		
	OPEN c_country;
	fetch c_country INTO v_country_id;
	close c_country;
	
	RETURN fn_get_country_attribute_by_id(v_country_id, 'name');
END
$$
delimiter ;

SELECT fn_get_country_name_by_city_name('Medellin')

