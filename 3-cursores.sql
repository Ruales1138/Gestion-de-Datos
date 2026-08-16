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
-- 4 -----------------------------------------------------------
-- 5 -----------------------------------------------------------