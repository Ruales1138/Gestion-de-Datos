-- 1 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_summation_01;

delimiter $$
CREATE FUNCTION fn_summation_01(
	p_min INT, 
	p_max INT
)
RETURNS INT 
BEGIN 
	DECLARE v_result INT default 0;
	FOR i IN p_min..p_max do
		SET v_result := v_result + i;
	END FOR;
	RETURN v_result;
END;
$$
delimiter ;

SELECT fn_summation_01(4,10)

-- 2 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_summation_02;

delimiter $$
CREATE FUNCTION fn_summation_02(
	p_min INT, 
	p_max INT
)
RETURNS INT 
BEGIN 
	DECLARE v_result INT default 0;
	FOR i IN p_min..p_max do
		if i % 2 <> 0 then
			SET v_result := v_result + i;
		END if;
	END FOR;
	RETURN v_result;
END;
$$
delimiter ;

SELECT fn_summation_02(1,10)

-- 3 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_factorial_01;

delimiter $$
CREATE FUNCTION fn_factorial_01(
	p_val1 INT 
)
RETURNS INT
BEGIN 
	DECLARE v_result INT DEFAULT 1;
	FOR i IN 1..p_val1 do
		SET v_result := v_result * i;
	END FOR;
	RETURN v_result;
END;
$$
delimiter ;

SELECT fn_factorial_01(5)

-- 4 -----------------------------------------------------------

DROP FUNCTION if EXISTS fn_factorial_summation_01;

delimiter $$
CREATE FUNCTION fn_factorial_summation_01(
	p_val1 INT 
)
RETURNS INT
BEGIN 
	DECLARE v_result INT DEFAULT 1;
	DECLARE v_sum INT DEFAULT 0;
	DECLARE v_temp INT;
	FOR i IN 1..p_val1 do
		SET v_result := v_result * i;
	END FOR;
	SET v_temp := v_result;
	while v_temp > 0 do
		SET v_sum := v_sum + (v_temp % 10);
		SET v_temp := floor(v_temp / 10);
	END while;
	RETURN v_sum;
END;
$$
delimiter ;

SELECT fn_factorial_summation_01(5)
	