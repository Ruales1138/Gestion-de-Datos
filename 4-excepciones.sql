-- 1 -----------------------------------------------------------

DROP PROCEDURE IF EXISTS pr_add_country;

DELIMITER $$
CREATE PROCEDURE pr_add_country (
    IN p_id                  CHAR(3),
    IN p_name                VARCHAR(52),
    IN p_continent            VARCHAR(20),
    IN p_region               VARCHAR(26),
    IN p_surface_area         FLOAT,
    IN p_independence_year    SMALLINT,
    IN p_population           INT,
    IN p_life_expectancy      FLOAT,
    IN p_gnp                  FLOAT,
    IN p_gnp_old              FLOAT,
    IN p_local_name           VARCHAR(45),
    IN p_government_form      VARCHAR(45),
    IN p_head_of_state        VARCHAR(60),
    IN p_capital              INT,
    IN p_code2                CHAR(2)
)
BEGIN
	DECLARE exit handler FOR SQLSTATE '23000'
		BEGIN
			SIGNAL SQLSTATE '23000'
				SET MESSAGE_TEXT = 'Error: ya existe un país con ese id';
		END; 

    INSERT INTO countries (
        id, name, continent, region, surface_area,
        independence_year, population, life_expectancy,
        gnp, gnp_old, local_name, government_form,
        head_of_state, capital, code2
    )
    VALUES (
        p_id, p_name, p_continent, p_region, p_surface_area,
        p_independence_year, p_population, p_life_expectancy,
        p_gnp, p_gnp_old, p_local_name, p_government_form,
        p_head_of_state, p_capital, p_code2
    );
END;
$$
DELIMITER ;

CALL pr_add_country('COL', 'Colombia', 'South America', 'South America', 
                     1141748, 1810, 51000000, 77.3, 314000, 300000, 
                     'Colombia', 'Republic', 'Gustavo Petro', 1, 'CO');
                     
-- 2 -----------------------------------------------------------

DROP PROCEDURE IF EXISTS pr_add_city;

DELIMITER $$
CREATE PROCEDURE pr_add_city (
    IN p_name         VARCHAR(35),
    IN p_country_id    CHAR(3),
    IN p_district      VARCHAR(20),
    IN p_population    INT
)
BEGIN
	DECLARE exit handler FOR SQLSTATE '23000'
	BEGIN
		SIGNAL SQLSTATE '23000'
			SET MESSAGE_TEXT = 'Error: el país indicado no existe';
	END;

	INSERT INTO cities (
      `name`, country_id, district, population
    )
    VALUES (
       p_name, p_country_id, p_district, p_population
    );
END$$
DELIMITER ;

CALL pr_add_city('Bogotá', 'COL', 'Bogotá D.C.', 7412566);
CALL pr_add_city('Ciudad Ficticia', 'XXX', 'Distrito Falso', 1000);

-- 3 -----------------------------------------------------------

DROP PROCEDURE if EXISTS pr_add_language;

delimiter $$
CREATE PROCEDURE pr_add_language(
	IN p_country_id TYPE OF countries_languages.country_id,
	IN p_language CHAR(100),
	IN p_official CHAR(1),
	OUT p_records INT
)
BEGIN 
	if LENGTH(p_language) > 30 then
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error: el nombre del idioma no puede superar 30 caracteres';
	END if;
	
	if p_official NOT IN ('T', 'F') then
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Error: el valor de oficialidad debe ser "T" o "F"';
	END if;
	
	SET p_records := 0;
	
	INSERT INTO countries_languages (
		country_id, language_id, is_official, percentage
	)
	VALUES (
		p_country_id, p_language, p_official, 0
	);
	
	SET p_records := ROW_COUNT();
END; 
$$
delimiter ;

CALL pr_add_language('COL', 'Italian', 'F', @records);
SELECT @records AS registros_insertados;

-- 4 -----------------------------------------------------------

DROP FUNCTION IF EXISTS fn_get_country_attribute_by_id;

DELIMITER $$
CREATE FUNCTION fn_get_country_attribute_by_id(
    p_country_id TYPE OF countries.id,
    p_attribute VARCHAR(100)
)
RETURNS VARCHAR(100)
BEGIN
    DECLARE v_result VARCHAR(100) DEFAULT NULL;

    DECLARE c_name CURSOR FOR
        SELECT name
        FROM countries
        WHERE id = p_country_id;

    DECLARE c_continent CURSOR FOR
        SELECT continent
        FROM countries
        WHERE id = p_country_id;

    DECLARE EXIT HANDLER FOR NOT FOUND
        SET v_result = 'País no encontrado';

    IF LOWER(p_attribute) = 'name' THEN
        OPEN c_name;
        FETCH c_name INTO v_result;
        CLOSE c_name;

    ELSEIF LOWER(p_attribute) = 'continent' THEN
        OPEN c_continent;
        FETCH c_continent INTO v_result;
        CLOSE c_continent;
    END IF;

    RETURN v_result;
END;
$$
DELIMITER ;

SELECT fn_get_country_attribute_by_id('COL', 'name');
