import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'scripts_container.dart';

class DatabaseManager {
	Database _db;
	ScriptsContainer _sc;

	DatabaseManager(ScriptsContainer sc){
		_sc = sc;
		print("DatabaseManager inicialize !!!");
	}

	Future<Database> get db async {
		if (_db != null) {
			print("********* RETURN _db *********");
			return _db;
		}
		_db = await initDb();

		return _db;
	}

	Future initDb() async {
		Directory path = await getApplicationDocumentsDirectory();
		String dbPath = join(path.path, "database.db");

		print("initDb() iniciado.");
		print("*** " + dbPath + " ***");
		var db = await openDatabase(dbPath, version: 1, onCreate: _sc.create);
		print("*** FIN initDb() iniciado.***");
		return db;
	}

}