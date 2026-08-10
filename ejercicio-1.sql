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
	
	
	
	
	
	
	
	
	
	
	