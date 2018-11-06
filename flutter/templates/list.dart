import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'models/base/database_manager.dart';
import 'models/base/scripts_container.dart';
import 'models/[[#__TABLE_NAME__#]].dart';

class [[#__TABLE_NAME__#]]List extends StatefulWidget {
  @override
  _ListView[[#__TABLE_NAME__#]]State createState() => new _ListView[[#__TABLE_NAME__#]]State();
}

class _ListView[[#__TABLE_NAME__#]]State extends State<[[#__TABLE_NAME__#]]List> {

  DatabaseManager db_manager = new DatabaseManager(new ScriptsContainer());
  List<[[#__TABLE_NAME__#]]> tablaItems = new List();

  @override
  void initState() {
    super.initState();
    [[#__TABLE_NAME__#]] modelo = new [[#__TABLE_NAME__#]].init(db_manager);

    modelo.fetchAll().then((data) {
      setState(() {
        data.forEach((d) {
          tablaItems.add([[#__TABLE_NAME__#]].fromMap(d));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView',
      home: Scaffold(
        appBar: AppBar(
          title: Text('[[#__TABLE_NAME__#]] List'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: tablaItems.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 5.0),
                  ListTile(
                    title: Text(
                      '${tablaItems[position].id})- ${tablaItems[position].nombre}',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    subtitle: Text(
                      position.toString(),
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {

                      //Fluttertoast.showToast(
                      //  msg: 'ID: ${tablaItems[index].id}',
                      //  toastLength: Toast.LENGTH_LONG,
                      //);

                    },
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}