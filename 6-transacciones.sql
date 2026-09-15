-- 0 -----------------------------------------------------------

-- [Inicio: Solicitud de Transferencia]
--                   │
--                   ▼
--    1. Validar identidad y autenticación
--                   │
--                   ▼
--    2. Verificar estado de cuenta origen y saldo suficiente
--                   │
--                   ▼
-- ┌─────────────────────────────────────────────────────────────┐
-- │                 TRANSACCIÓN PRINCIPAL (ACID)                │
-- │                                                             │
-- │   3. Débito: Restar monto de la Cuenta Origen               │
-- │   4. Crédito: Sumar monto a la Cuenta Destino               │
-- │   5. Auditoría: Registrar movimiento en historial           │
-- │                                                             │
-- └─────────────────────────────────────────────────────────────┘
--                   │
--                   ▼
--    6. Notificar resultado al cliente (Email / SMS / Push)
--                   │
--                   ▼
--          [Fin del proceso]

START TRANSACTION;

-- Paso 3: Débito
UPDATE cuentas SET saldo = saldo - 100 WHERE id_cuenta = 'ORIGEN';

-- Paso 4: Crédito
UPDATE cuentas SET saldo = saldo + 100 WHERE id_cuenta = 'DESTINO';

-- Paso 5: Auditoría
INSERT INTO historial_transferencias (origen, destino, monto, fecha) 
VALUES ('ORIGEN', 'DESTINO', 100, NOW());

COMMIT;

-- 1 -----------------------------------------------------------

-- Sesion 1
-- Modificamos la población de un país (por ejemplo, id = 'COL' o el id de tu preferencia)
UPDATE countries 
SET population = 52000000 
WHERE id = 'COL';

-- Sesion 2
-- Consultamos el valor actualizado desde la otra sesión
SELECT id, name, population 
FROM countries 
WHERE id = 'COL';

-- 2 -----------------------------------------------------------

-- Sesion 1
-- Iniciar el bloque transaccional
START TRANSACTION;
-- Modificar la población (por ejemplo, id = 'ARG')
UPDATE countries 
SET population = 46000000 
WHERE id = 'ARG';
-- IMPORTANTE: NO ejecutes COMMIT ni ROLLBACK aún.

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id = 'ARG';

-- Sesion 1
COMMIT;

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id = 'ARG';

-- 3 -----------------------------------------------------------

-- Sesion 1
-- Iniciar la transacción manual
START TRANSACTION;
-- Modificar la población (por ejemplo, id = 'BRA')
UPDATE countries 
SET population = 220000000 
WHERE id = 'BRA';
-- IMPORTANTE: NO ejecutes COMMIT ni ROLLBACK aún.

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id = 'BRA';

-- Sesion 1
ROLLBACK;

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id = 'BRA';

-- 4 -----------------------------------------------------------

-- Sesion 1
START TRANSACTION;
-- 1. Aumentar 10% a Colombia (COL)
UPDATE countries SET population = population * 1.10 WHERE id = 'COL';
SAVEPOINT sp_colombia;
-- 2. Aumentar 10% a Argentina (ARG)
UPDATE countries SET population = population * 1.10 WHERE id = 'ARG';
SAVEPOINT sp_argentina;
-- 3. Aumentar 10% a Venezuela (VEN)
UPDATE countries SET population = population * 1.10 WHERE id = 'VEN';
SAVEPOINT sp_venezuela;
-- IMPORTANTE: NO ejecutes COMMIT ni ROLLBACK aún.

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id IN ('COL', 'ARG', 'VEN');

-- Sesion 1
ROLLBACK TO sp_colombia;

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id IN ('COL', 'ARG', 'VEN');

-- Sesion 1
COMMIT;

-- Sesion 2
SELECT id, name, population 
FROM countries 
WHERE id IN ('COL', 'ARG', 'VEN');  