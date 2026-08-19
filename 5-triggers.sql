-- 1 -----------------------------------------------------------

CREATE TABLE if NOT EXISTS cities_history(
	id             INT(11) NOT NULL AUTO_INCREMENT,
   city_id        INT(11) NOT NULL,
   event_date     DATETIME NOT NULL,
   event_user     VARCHAR(100) NOT NULL,
   event_action   VARCHAR(30) NOT NULL,
   value_before   VARCHAR(255) NULL,
   value_after    VARCHAR(255) NULL,
   PRIMARY KEY (id)
);

DROP TRIGGER if EXISTS tr_audit_city_delete;

delimiter $$
CREATE TRIGGER tr_audit_city_delete
AFTER DELETE ON cities
FOR EACH ROW 
BEGIN
	INSERT INTO cities_history (
		city_id, event_date, event_user, event_action, value_before, value_after
	)
	VALUES (
		OLD.id,
		NOW(),
		USER(),
		'DELETE CITY',
		CONCAT(OLD.name, ', ', OLD.country_id, ', ', OLD.district, ', ', OLD.population),
		NULL
	);
END;
$$
delimiter ;

DELETE FROM cities WHERE id = 1;
SELECT * FROM cities_history;

-- 2 -----------------------------------------------------------

DROP TRIGGER IF EXISTS tr_audit_city_insert;
DELIMITER $$

CREATE TRIGGER tr_audit_city_insert
AFTER INSERT ON cities
FOR EACH ROW
BEGIN
    INSERT INTO cities_history (
        city_id, event_date, event_user, event_action, value_before, value_after
    )
    VALUES (
        NEW.id,
        NOW(),
        USER(),
        'CREATE CITY',
        NULL,
        CONCAT(NEW.name, ', ', NEW.country_id, ', ', NEW.district, ', ', NEW.population)
    );
END;
$$
DELIMITER ;

CALL pr_add_city('Cali', 'COL', 'Valle del Cauca', 2227642);

SELECT * FROM cities_history ORDER BY id DESC LIMIT 1;

-- 3 -----------------------------------------------------------

DROP TRIGGER if EXISTS tr_before_update_city_population;

delimiter $$
CREATE TRIGGER tr_before_update_city_population
BEFORE UPDATE ON cities
FOR EACH ROW 
BEGIN
	SET NEW.population = NEW.population + 1;
	INSERT INTO cities_history (
        city_id, event_date, event_user, event_action, value_before, value_after
    )
    VALUES (
        OLD.id,
        NOW(),
        USER(),
        'UPDATE POPULATION',
        OLD.population,
        NEW.population
    );
END;
$$
delimiter ;

SELECT id, name, population FROM cities WHERE id = 1;
UPDATE cities SET population = 100000 WHERE id = 1;
SELECT id, name, population FROM cities WHERE id = 1;
SELECT * FROM cities_history ORDER BY id DESC LIMIT 1;