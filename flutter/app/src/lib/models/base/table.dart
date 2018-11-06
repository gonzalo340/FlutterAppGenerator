import 'dart:async';
import 'database_manager.dart';

class Table {
	DatabaseManager _db_manager;
	String _nombre;

	Table();

	Table.init(DatabaseManager db_manager, String nombre) {
		_db_manager = db_manager;
		_nombre = nombre;
	}

	String getNombreTabla(){
		return _nombre;
	}

	/* Metodos y atributos de la clase que la herada (Los defino simplemente para que existan cuando los quiero llamar desde esta clase) */
	Map<String, dynamic> toMap() {
		return new Map<String, dynamic>();
	}
	final columns = ["id"];
	int id;
	String nombre;
	/* FIN Metodos y atributos de la clase que la herada*/

	Future<Table> insert() async {
		var dbClient = await _db_manager.db;
		this.id = await dbClient.insert(this.getNombreTabla(), this.toMap());
		print("INSERT " + this.nombre);
		return this;
	}

	Future<List<Map>> fetchAll() async {
		var dbClient = await _db_manager.db;

		List<Map> results = await dbClient.query(this.getNombreTabla(), columns: this.columns);

		print("fetchAll(): results.length = " + results.length.toString());

		return results;
	}

}