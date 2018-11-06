import 'dart:io';

class Generate {

	Generate(String filename, callback){
		new File(filename).readAsString().then((String contents) {

			contents = contents.replaceAll(new RegExp(r"\r\n"), " ");
			contents = contents.replaceAll(new RegExp(r"\d,\ {0,}\d"), "#DECIMAL#");

			/* Obtengo nombre de tablas y campos de base de datos */
			RegExp exp = new RegExp(r"CREATE\ {0,}TABLE\ {0,}(\w+)\ {0,}\((.*?)\);");
			Iterable<Match> matches = exp.allMatches(contents);

			List<Tabla> tablas = new List<Tabla>();

			for(Match m in matches){
				String nombre_tabla = m.group(1);
				List<String> campos = m.group(2).split(",");

				tablas.add(new Tabla(nombre_tabla, campos));
			}
			/* Obtengo nombre de tablas y campos de base de datos */

			callback(tablas);
		});
	}
}

class Tabla {

	String _nombre;
	List<Campo> _campos;

	Tabla(nombre, List<String> campos){
		_nombre = nombre;
		_campos = new List<Campo>();

		for(int i=0; i<campos.length; i++){
			List<String> v = campos[i].trim().split(" ");

			String campo_nombre = "";
			String campo_tipo = "";

			for(int i=0; i<v.length; i++){
				if(i == 0){
					campo_nombre = v[i];
				}else{
					if(v[i] != " "){
						campo_tipo += v[i];
					}
				}
			}

			_campos.add(new Campo(campo_nombre, campo_tipo));
		}
	}

	String getTablaNombre(){
		return _nombre;
	}

	List<Campo> getListaCampos(){
		return _campos;
	}
}

class Campo {
	String _nombre;
	String _tipo;

	Campo(nombre, tipo){
		_nombre = nombre;
		_tipo = tipo;
	}

	String getNombre(){
		return _nombre;
	}
	String getTipo(){
		return _tipo;
	}
}

class Clase {

	String _nombre;
	List<String> _atributos;
	List<Campo> campos;

	Clase(Tabla tabla){

		_nombre = tabla.getTablaNombre();
		_atributos = new List<String>();

		campos = tabla.getListaCampos();
		int cant_campos = campos.length;

		for(int i=0; i<cant_campos; i++){
			String nombre_campo = campos[i].getNombre();
			String tipo_campo = campos[i].getTipo().toUpperCase();

			switch(tipo_campo){
				case 'INTEGER':
					_atributos.add("int " + nombre_campo.toLowerCase() + ";");
					break;
				default:

					tipo_campo = tipo_campo + ".........."; // Le coloco puntos a la derecha para que supere los 7 caracteres y no de error el substring.
					
					if(tipo_campo.substring(0, 4) == "CHAR" || tipo_campo.substring(0, 7) == "VARCHAR"){
						_atributos.add("String " + nombre_campo.toLowerCase() + ";");						
					}else if(tipo_campo.substring(0, 6) == "NUMBER"){
						_atributos.add("num " + nombre_campo.toLowerCase() + ";");
					}else if(tipo_campo.substring(0, 3) == "INT" || tipo_campo.substring(0, 9) == "MEDIUMINT" || tipo_campo.substring(0, 6) == "BIGINT"){
						_atributos.add("int " + nombre_campo.toLowerCase() + ";");
					}

					break;
			}
		}
	}

	void guardar_sql_script(String filename){
		new File(filename).writeAsString(get_script()).then((File file) {
			print(filename + " generado.");
		});
	}

	void guardar(String filename){

		String contenido = "";

		contenido += "import 'dart:convert';\r\n";
		contenido += "import 'base/table.dart';\r\n";
		contenido += "import 'base/database_manager.dart';\r\n";

		contenido += "\r\n";
		contenido += "class "+_nombre+" extends Table {\r\n";
		contenido += "\t"+_nombre+"();\r\n";
		contenido += "\t" + _nombre + ".init(DatabaseManager db_manager) : super.init(db_manager, \"" + _nombre.toLowerCase() + "\");\r\n";
		contenido += "\r\n";

		/* Recorro todos los atributos */
		bool existe_id = false;
		String cols = "";
		String maps = "";
		String from_map = "";
		for(int i=0; i<_atributos.length; i++){
			contenido += "\t"+_atributos[i] + "\r\n";
			cols += "\"" + campos[i].getNombre().toLowerCase() + "\", ";

			String nombre_campo_minuscula = campos[i].getNombre().toLowerCase();

			if(nombre_campo_minuscula != 'id') maps += "\t\tmap['" + nombre_campo_minuscula + "'] = " + nombre_campo_minuscula + ";\r\n";

			from_map += "\t\tdata." + campos[i].getNombre().toLowerCase() + " = map[\"" + campos[i].getNombre().toLowerCase() + "\"];\r\n";

			if(campos[i].getNombre().toLowerCase() == "id") existe_id = true;
		}
		/* FIN Recorro todos los atributos */

		// Saco la ultima coma
		if(cols != "") cols = cols.substring(0, cols.length-2);

		/* Genero el atributo statico columns */
		contenido += "\r\n";
		contenido += "\tfinal columns = ["+cols.trim()+"];\r\n";
		contenido += "\r\n";
		/* FIN Genero el atributo statico columns */

		/* Genero la funcion toMap */
		contenido += "\tMap<String, dynamic> toMap() {\r\n";
		
		contenido += "\t\tvar map = new Map<String, dynamic>();\r\n";
		contenido += "\r\n";

		contenido += maps;
		contenido += "\r\n";

		if(existe_id){
			contenido += "\t\tif (id != null) {\r\n";
			contenido += "\t\t\tmap[\"id\"] = id;\r\n";
			contenido += "\t\t}\r\n";
			contenido += "\r\n";
		}

		contenido += "\t\treturn map;\r\n";
		contenido += "\t}\r\n";
		/* FIN Genero la funcion toMap */

		/* Genero la function static fromMap */
		contenido += "\r\n";
		contenido += "\tstatic fromMap(Map map) {\r\n";
		contenido += "\t\t" + _nombre + " data = new " + _nombre + "();\r\n";
		contenido += from_map;
		contenido += "\r\n";
		contenido += "\t\treturn data;\r\n";
		contenido += "\t}\r\n";
		/* FIN Genero la function static fromMap */

		// Cierro el corchete de la clase.
		contenido += "}\r\n";

		new File(filename).writeAsString(contenido).then((File file) {
			print(filename + " generado.");
		});

	}

	void get_script(){
		String contenido = "";
		contenido += "CREATE TABLE IF NOT EXISTS " + _nombre + " (";

		int cant_campos = campos.length;

		for(int i=0; i<cant_campos; i++){
			String nombre_campo = campos[i].getNombre().toLowerCase();
			String tipo_campo   = campos[i].getTipo().toUpperCase();

			switch(tipo_campo){
				case 'INTEGER':
					contenido += nombre_campo + " INTEGER NOT NULL, ";
					break;
				default:

					tipo_campo = tipo_campo + ".........."; // Le coloco puntos a la derecha para que supere los 7 caracteres y no de error el substring.
					
					if(tipo_campo.substring(0, 4) == "CHAR" || tipo_campo.substring(0, 7) == "VARCHAR"){
						contenido += nombre_campo + " VARCHAR NOT NULL, ";
					}else if(tipo_campo.substring(0, 6) == "NUMBER"){
						contenido += nombre_campo + " NUMBER NOT NULL, ";
					}else if(tipo_campo.substring(0, 3) == "INT" || tipo_campo.substring(0, 9) == "MEDIUMINT" || tipo_campo.substring(0, 6) == "BIGINT"){
						contenido += nombre_campo + " INTEGER NOT NULL, ";
					}

					break;
			}

		}
		// Quito la ultima coma
		contenido = contenido.substring(0, contenido.length-2);

		contenido += ")";

		return contenido;
	}
}

class FlutterGenerator {

	String _path;
	String _template_name;
	String _modelo;

	FlutterGenerator(String path, String template_name, String modelo){
		_path = path;
		_template_name = template_name;
		_modelo = modelo;
	}

	void generate(){

		print("Generando flutter model " + _modelo);

		new File("flutter/templates/"+_template_name+".dart").readAsString().then((String contenido_plantilla) {
			String contenido = contenido_plantilla.replaceAll(new RegExp(r"\[\[#__TABLE_NAME__#\]\]"), _modelo);

			new File(_path).writeAsString(contenido).then((File file) {
				print("[Flutter model " + _modelo + "] " + _path + " generado.");
			});

		});
	}
}