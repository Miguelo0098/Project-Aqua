import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/widgets/drawer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/add_location.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'list_details.dart';

class ListsLocation extends StatefulWidget {
    static const String route = '/locations';

  @override 
  _ListsLocationState createState() => _ListsLocationState();
}

class _ListsLocationState extends State<ListsLocation> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<LocationClass> listLocation;
  int countList = 0;

  @override 
  Widget build(BuildContext ctx) {
    
    if (listLocation == null) {
      listLocation = List<LocationClass>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Active Location List'),),
      drawer: buildDrawer(context, ListsLocation.route),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToLocationForm(LocationClass('', 0, 0, ''), 'Add List');
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
              backgroundColor: Colors.blue,
              child: Icon(Icons.location_on, color: Colors.white),
            ),
            title: Text(
              this.listLocation[position].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text(this.listLocation[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.share, color: Colors.black),
                  onTap: (){
                    _showQRCode(context, listLocation[position]);
                  },
                )
              ],
            ),
            onTap: (){
              debugPrint('List Selected');
              navigateToLocationForm(this.listLocation[position], 'Edit Location');
            }
          ),
        );
      },
    );
  }


  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<LocationClass>> listLocationFuture = databaseHelper.getLocationList();
      listLocationFuture.then((listLocation){
        setState((){
          this.listLocation = listLocation;
          this.countList = listLocation.length;
        });
      });
    });
  }
  
  void navigateToLocationForm(LocationClass location, String title)async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddLocationForm(title, location);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void _showQRCode(BuildContext context, LocationClass location){
    
    AlertDialog alertDialog = AlertDialog(
        title: Text(location.title),
        content: QrImage(
          data: location.toJson(),
          version: QrVersions.auto,
          size: 200.0,
        )
      );
      showDialog(
        context: context,
        builder: (_) => alertDialog,
      );
  }
}