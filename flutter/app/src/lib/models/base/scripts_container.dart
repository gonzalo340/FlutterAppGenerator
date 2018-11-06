import 'dart:async';
import 'package:sqflite/sqflite.dart';

class ScriptsContainer {

	Future create(Database db, int version) async {
		
		print("*** Creando TODAS las TABLAS ***");

		//await db.execute("CREATE TABLE IF NOT EXISTS Example1 (id INTEGER NOT NULL, nombre VARCHAR NOT NULL)");
		//await db.execute("CREATE TABLE IF NOT EXISTS Example2 (id INTEGER NOT NULL, nombre VARCHAR NOT NULL)");
	}
}