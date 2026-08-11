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
-- 3 -----------------------------------------------------------
-- 4 -----------------------------------------------------------
-- 5 -----------------------------------------------------------