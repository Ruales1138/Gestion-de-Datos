-- 1 -----------------------------------------------------------

delimiter $$
CREATE FUNCTION fn_addition_01(
	p_min INT,
	p_max INT 
)
RETURNS INT 
DETERMINISTIC
BEGIN 
	DECLARE result INT;
	SET result := p_min + p_max;
	RETURN result;
END;
$$
delimiter $$

SELECT fn_addition_01(10, 1)
	
-- 2 -----------------------------------------------------------

DROP FUNCTION IF EXISTS fn_triangle_area;

delimiter $$
CREATE FUNCTION fn_triangle_area(
	p_side FLOAT, 
	p_height FLOAT  
)
RETURNS FLOAT 
DETERMINISTIC 
BEGIN
	DECLARE result FLOAT;
	SET result := (p_side * p_height) / 2;
	RETURN result;
END;
$$
delimiter ;

SELECT fn_triangle_area(3, 5)
	
-- 3 -----------------------------------------------------------

delimiter $$
CREATE FUNCTION fn_arithmetic_operation_01(
	p_val1 INT,
	p_val2 INT, 
	p_operation VARCHAR(100)
)
RETURNS REAL
DETERMINISTIC 
BEGIN
	DECLARE v_result REAL;
	if p_operation = 'addition' then 
		SET v_result := p_val1 + p_val2;
	ELSEIF p_operation = 'subtraction' then
		SET v_result := p_val1 - p_val2;
	ELSEIF p_operation = 'multiplication' then
		SET v_result := p_val1 * p_val2;
	ELSEIF p_operation = 'division' then
		SET v_result := p_val1 / p_val2;
	ELSE 
		SET v_result := 0;
	END if;
	RETURN v_result;
END;
$$
delimiter ;

-- 4 -----------------------------------------------------------

delimiter $$
CREATE FUNCTION fn_number_type_01(
	p_number INT 
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE v_result VARCHAR(100);
	if p_number % 2 = 0 then
		SET v_result := 'EVEN';
	else
		SET v_result := 'ODD';
	END if;
	RETURN v_result;
END
$$
delimiter ;

-- 5 -----------------------------------------------------------
	
DROP FUNCTION if EXISTS fn_is_triangle_area_even_01;

delimiter $$
CREATE FUNCTION fn_is_triangle_area_even_01(
	p_side FLOAT, 
	p_height FLOAT  
)
RETURNS VARCHAR(100)
DETERMINISTIC 
BEGIN
	DECLARE text_result VARCHAR(100);
	DECLARE result FLOAT;
	SET result := (p_side * p_height) / 2;
	if result % 2 = 0 then
		SET text_result := 'YES';
	else
		SET text_result := 'NO';
	END if;
	RETURN text_result;
END;
$$
delimiter ;

SELECT fn_is_triangle_area_even_01(3, 5)
	
	
	
	
	
	
	
	