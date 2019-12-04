import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/add_location.dart';
import 'package:sqflite/sqflite.dart';

import 'list_details.dart';

class SelectListPage extends StatefulWidget {
  @override 
  _SelectListPageState createState() => _SelectListPageState();
}

class _SelectListPageState extends State<SelectListPage> {
  static const String route = '/selectList';
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ListClass> listList;
  int countList = 0;

  @override 
  Widget build(BuildContext ctx) {
    if (listList == null) {
      listList = List<ListClass>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Select a List'),),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToListForm(ListClass('', 0, ''), 'Add List');
        },
        tooltip: 'Add a List',
        child: Icon(Icons.add),
      ),

    );
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<ListClass>> listListFuture = databaseHelper.getListList();
      listListFuture.then((listList){
        setState((){
          this.listList = listList;
          this.countList = listList.length;
        });
      });
    });
  }

  ListView getListView(){
    return ListView.builder(
      itemCount: countList,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.list),
            ),
            title: Text(
              this.listList[position].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text(this.listList[position].description),
            onTap: (){
              debugPrint('List Selected');
              navigateToLocationForm(this.listList[position].id);
            }
          ),
        );
      },
    );
  }

  void navigateToLocationForm(int idList) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddLocationForm('Add a Location', LocationClass('', idList, 0.0, 0.0));
    }));
    if (result == true) {
      updateListView();
    }
  }

  void navigateToListForm(ListClass list, String title)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return ListDetails(list, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
}