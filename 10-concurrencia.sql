-- 1 -----------------------------------------------------------

-- Control de Concurrencia Pesimista (Bloqueo de filas)
START TRANSACTION;
-- Bloquea la fila del asiento K11 para que nadie más la lea o modifique
SELECT status 
FROM seats 
WHERE theater = 'XYZ' AND seat_id = 'K11' 
FOR UPDATE;
-- Si el status es 'FREE', se procede con la actualización
UPDATE seats 
SET status = 'RESERVED', user_id = 'Leidy' 
WHERE theater = 'XYZ' AND seat_id = 'K11';
COMMIT;

-- Control de Concurrencia Optimista (Validación de estado previo)
UPDATE seats
SET status = 'RESERVED', user_id = 'Diana'
WHERE theater = 'XYZ' AND seat_id = 'K11' AND status = 'FREE';

-- 2 -----------------------------------------------------------

-- Abrazo mortal DEADLOCK

CREATE TABLE cuenta (
    id INT PRIMARY KEY,
    saldo INT
) ENGINE = InnoDB;
INSERT INTO cuenta VALUES (1, 1000), (2, 2000);

-- Sesion 1
START TRANSACTION;

-- Sesion 2
START TRANSACTION;

-- Sesion 1
UPDATE cuenta SET saldo = saldo - 100 WHERE id = 1;

-- Sesion 2
UPDATE cuenta SET saldo = saldo - 200 WHERE id = 2;

-- Sesion 1
UPDATE cuenta SET saldo = saldo + 100 WHERE id = 2;