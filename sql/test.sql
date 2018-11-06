--
-- File generated with SQLiteStudio v3.1.0 on lun nov 5 21:21:07 2018
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: categorias
CREATE TABLE categorias (id INTEGER PRIMARY KEY, nombre VARCHAR (50));

-- Table: personas
CREATE TABLE personas (id INTEGER PRIMARY KEY, nombre VARCHAR (50), apellidos VARCHAR (50), edad INTEGER, categoria_id INTEGER);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;