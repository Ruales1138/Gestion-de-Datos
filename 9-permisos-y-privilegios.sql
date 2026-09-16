
-- ====================================================================
-- SCRIPT DE ASIGNACIÓN DE PRIVILEGIOS POR ROLES (EJERCICIO 1)
-- Base de datos objetivo: world
-- Motor: MariaDB / MySQL
-- ====================================================================

-- 1. CREACIÓN DE LOS ROLES
-- Creamos los tres roles requeridos para el ejercicio
CREATE ROLE IF NOT EXISTS dev_role;   -- Rol para Desarrolladores
CREATE ROLE IF NOT EXISTS qa_role;    -- Rol para Analistas de Pruebas
CREATE ROLE IF NOT EXISTS biz_role;   -- Rol para Analistas de Negocio


-- ====================================================================
-- 2. ROL DE DESARROLLADORES (dev_role)
-- ====================================================================

-- A. Operaciones DML: insert y select sobre las tablas 'cities' y 'countries'
GRANT SELECT, INSERT ON world.cities TO dev_role;[cite: 1]
GRANT SELECT, INSERT ON world.countries TO dev_role;[cite: 1]

-- B. Operaciones DDL sobre Rutinas: crear, modificar y eliminar funciones/procedimientos
-- Nota: ALTER ROUTINE permite tanto modificar como eliminar (DROP) rutinas en MariaDB/MySQL
GRANT CREATE ROUTINE, ALTER ROUTINE ON world.* TO dev_role;[cite: 1]


-- ====================================================================
-- 3. ROL DE ANALISTAS DE PRUEBAS (qa_role)
-- ====================================================================

-- Operaciones DML completas: insert, select, update, delete sobre las 4 tablas indicadas
GRANT SELECT, INSERT, UPDATE, DELETE ON world.cities TO qa_role;[cite: 1]
GRANT SELECT, INSERT, UPDATE, DELETE ON world.countries TO qa_role;[cite: 1]
GRANT SELECT, INSERT, UPDATE, DELETE ON world.languages TO qa_role;[cite: 1]
GRANT SELECT, INSERT, UPDATE, DELETE ON world.countries_languages TO qa_role;[cite: 1]


-- ====================================================================
-- 4. ROL DE ANALISTAS DE NEGOCIO (biz_role)
-- ====================================================================

-- Consulta (select) sobre la instancia completa (*.*)
GRANT SELECT ON *.* TO biz_role;[cite: 1]


-- ====================================================================
-- 5. RECARGA DE TABLAS DE PRIVILEGIOS
-- ====================================================================

-- Aplica inmediatamente todos los cambios en la memoria del motor de base de datos
FLUSH PRIVILEGES;[cite: 1]
