-- 1 -----------------------------------------------------------

-- ============================================================
-- 1. CREACIÓN DE ROLES
-- ============================================================
CREATE ROLE developer;
CREATE ROLE qa;
CREATE ROLE business;

-- ============================================================
-- 2. CREACIÓN DE USUARIOS
-- ============================================================

-- Desarrolladores (Acceso desde cualquier host '%')
CREATE USER 'ldavinci'@'%' IDENTIFIED BY 'Password123!';
CREATE USER 'inewton'@'%' IDENTIFIED BY 'Password123!';
CREATE USER 'ntesla'@'%' IDENTIFIED BY 'Password123!';
CREATE USER 'mfaraday'@'%' IDENTIFIED BY 'Password123!';

-- Analistas de Pruebas - QA (Acceso desde la subred 192.168.5.0/24)
CREATE USER 'ggalilei'@'192.168.5.0/255.255.255.0' IDENTIFIED BY 'Password123!';
CREATE USER 'mcurie'@'192.168.5.0/255.255.255.0' IDENTIFIED BY 'Password123!';
CREATE USER 'cdarwin'@'192.168.5.0/255.255.255.0' IDENTIFIED BY 'Password123!';

-- Analistas de Negocio (IPs fijas específicas)
CREATE USER 'gbell'@'192.168.5.51' IDENTIFIED BY 'Password123!';
CREATE USER 'ncoperni'@'192.168.5.52' IDENTIFIED BY 'Password123!';

-- ============================================================
-- 3. ASIGNACIÓN DE ROLES A USUARIOS
-- ============================================================

-- Rol: Developer
GRANT developer TO 'ldavinci'@'%';
GRANT developer TO 'inewton'@'%';
GRANT developer TO 'ntesla'@'%';
GRANT developer TO 'mfaraday'@'%';

-- Rol: QA
GRANT qa TO 'ggalilei'@'192.168.5.0/255.255.255.0';
GRANT qa TO 'mcurie'@'192.168.5.0/255.255.255.0';
GRANT qa TO 'cdarwin'@'192.168.5.0/255.255.255.0';

-- Rol: Business
GRANT business TO 'gbell'@'192.168.5.51';
GRANT business TO 'ncoperni'@'192.168.5.52';

-- ============================================================
-- 4. APLICACIÓN DE LÍMITES DE EJECUCIÓN (RESTRICCIONES)
-- ============================================================

-- Límites para QA (30 consultas/hora, 40 actualizaciones/hora, max 1 conexión simultánea)
ALTER USER 'ggalilei'@'192.168.5.0/255.255.255.0' WITH 
  MAX_QUERIES_PER_HOUR 30 
  MAX_UPDATES_PER_HOUR 40 
  MAX_USER_CONNECTIONS 1;

ALTER USER 'mcurie'@'192.168.5.0/255.255.255.0' WITH 
  MAX_QUERIES_PER_HOUR 30 
  MAX_UPDATES_PER_HOUR 40 
  MAX_USER_CONNECTIONS 1;

ALTER USER 'cdarwin'@'192.168.5.0/255.255.255.0' WITH 
  MAX_QUERIES_PER_HOUR 30 
  MAX_UPDATES_PER_HOUR 40 
  MAX_USER_CONNECTIONS 1;

-- Límites para Analistas de Negocio (Max 1 conexión simultánea)
ALTER USER 'gbell'@'192.168.5.51' WITH 
  MAX_USER_CONNECTIONS 1;

ALTER USER 'ncoperni'@'192.168.5.52' WITH 
  MAX_USER_CONNECTIONS 1;