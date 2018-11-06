import './generate.dart';

void main() {
	Generate gen = new Generate("sql/test.sql", gen_resp);
}

void gen_resp(List<Tabla> tablas){

	String executes = "";

	for(int i=0; i<tablas.length; i++){

		/* Genero las clases para cada tabla */

		String path_src = "./flutter/app/src/";
		String path_lib = path_src + "lib/";
		String path_models = path_lib + "models/";

		Clase cla = new Clase(tablas[i]);
		cla.guardar(path_models + tablas[i].getTablaNombre()+".dart");
		cla.guardar_sql_script(path_src + "scripts/" + tablas[i].getTablaNombre()+".sql");

		executes += "await db.execute(\"" + cla.get_script() + "\");\r\n";

		/* Genero las vistas (ListView) de flutter para cada tabla */
		FlutterGenerator flutter_gen = new FlutterGenerator(path_lib + tablas[i].getTablaNombre() + "_list.dart", "list", tablas[i].getTablaNombre());
		flutter_gen.generate();

	}

	print("--- Executes ---");
	print(executes);
	print("--- FIN Executes ---");
}