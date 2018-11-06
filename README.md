# FlutterAppGenerator
## Generador de aplicaciones Flutter


### PASO 1:
git clone https://github.com/gonzalo340/FlutterAppGenerator

### PASO 2:
cd FlutterAppGenerator/

### PASO 3:
Cambiar el contenido del script sql/test.sql para crear sus propias tablas.

### PASO 4:
Dentro de la carpeta FlutterAppGenerator/flutter/app/src/ crear la carpeta scripts

### PASO 5:
Ejecutar el comando: dart make.dart

La salida del comando se vera parecida a esto:

Generando flutter model categorias
Generando flutter model personas
--- Executes ---
await db.execute("CREATE TABLE IF NOT EXISTS categorias (id INTEGER NOT NULL, nombre VARCHAR NOT NULL)");
await db.execute("CREATE TABLE IF NOT EXISTS personas (id INTEGER NOT NULL, nombre VARCHAR NOT NULL, apellidos VARCHAR NOT NULL, edad INTEGER NOT NULL, categoria_id INTEGER NOT NULL)");

--- FIN Executes ---
./flutter/app/src/lib/models/categorias.dart generado.
./flutter/app/src/scripts/categorias.sql generado.
./flutter/app/src/lib/models/personas.dart generado.
./flutter/app/src/scripts/personas.sql generado.
[Flutter model categorias] ./flutter/app/src/lib/categorias_list.dart generado.
[Flutter model personas] ./flutter/app/src/lib/personas_list.dart generado.

### PASO 6:
Copiar todos los executes que devolvio el comando anterior en el archivo FlutterAppGenerator/flutter/app/src/lib/models/base/scripts_container.dart dentro del metodo "Future create".

### PASO 7:
Copiar todo el contenido de la carpeta FlutterAppGenerator/flutter/app/src/lib/ dentro de la carpeta "lib" de su aplicacion de Flutter.

### PASO 8:
Colocar en las dependencias de flutter los siguientes 2 paquetes (archivo pubspec.yaml):
 - sqflite: any
 - path_provider: any

### PASO 9:
Esto es todo.
Ejecutar la aplicacion con Android Studio, o desde comando (flutter run)

#### Detalles:
 - Existe un directorio de plantillas para configurar como se veran las vistas de flutter en el dispositivo.
 - Por el momento, no se genera ningun main.dart, este archivo se debe crear a mano y luego colocar botones que lleven a las pantallas de las vistas generadas. Tambien se puede usar una de las vistas generadas como main. Para eso renombre una vista cualquiera a main.dart, y dentro del archivo colocar el metodo "void main()".