-- Cine -----------------------------------------------------------

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