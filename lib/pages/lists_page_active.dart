import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';
//import 'package:project_aqua/data/list_class.dart';
import 'package:project_aqua/widgets/drawer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/add_location.dart';

//import 'list_details.dart';

class ListsLocation extends StatefulWidget {
    static const String route = '/locations';

  @override 
  _ListsLocationState createState() => _ListsLocationState();
}

class _ListsLocationState extends State<ListsLocation> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  ListClass activeList;
  List<LocationClass> listLocation;
  int countList = 0;

  @override 
  Widget build(BuildContext ctx) {
    setActiveList();
    if (activeList == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Active Location List'),),
        drawer: buildDrawer(context, ListsLocation.route),
        body: Text(
          "No active location list available. Maybe you should mark one as active.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        )
      );
    }
    
    if (listLocation == null) {
      listLocation = List<LocationClass>();
      updateListView(activeList.id);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Active Location List'),),
      drawer: buildDrawer(context, ListsLocation.route),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToLocationForm(LocationClass('', 0, 0, 0), 'Add List', activeList.id);
        },
        tooltip: 'Add a List',
        child: Icon(Icons.add),
      ),

    );
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
              this.listLocation[position].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text(this.listLocation[position].description),
            onTap: (){
              debugPrint('List Selected');
              navigateToLocationForm(this.listLocation[position], 'Edit Location', activeList.id);
            }
          ),
        );
      },
    );
  }

  void setActiveList(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<ListClass> activeListFuture = databaseHelper.getActiveList();
      activeListFuture.then((activeList){
        setState((){
          this.activeList = activeList;
        });
      });
    });
  }

  void updateListView(int idlist){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<LocationClass>> listLocationFuture = databaseHelper.getLocationList(idlist);
      listLocationFuture.then((listLocation){
        setState((){
          this.listLocation = listLocation;
          this.countList = listLocation.length;
        });
      });
    });
  }
  
  void navigateToLocationForm(LocationClass location, String title, int idlist)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddLocationForm(title, location);
    }));

    if (result == true) {
      updateListView(idlist);
    }
  }
}