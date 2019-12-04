import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/select_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_location/user_location.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  MapController mapController = MapController();
  List<Marker> markers = [];

  List<LocationClass> locations;
  int countList = 0;
  ListClass activeList;

  @override
  Widget build(BuildContext context){
    setActiveList();
    if (activeList != null) {
      if(locations == null){
        locations = List<LocationClass>();
        updateListView(activeList.id);
        updateMarkers();
      }
      
    }
    return Scaffold(
      appBar: AppBar(title: Text("Street Map"),),
      drawer: buildDrawer(context, HomePage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map (obviously)'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(0, 0),
                  zoom: 15.0,
                  plugins: [
                    UserLocationPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(markers: markers),
                  UserLocationOptions(
                    context: context,
                    mapController: mapController,
                    markers: markers,
                  ),
                ],
                  mapController: mapController
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectListPage())
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_location),
      ),
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
          this.locations = listLocation;
          this.countList = listLocation.length;
        });
      });
    });
  }

  void updateMarkers(){
    Marker auxMarker;
    for (var location in this.locations) {
      auxMarker = Marker(
        width: 24.0,
        height: 24.0,
        point: LatLng(location.latitude, location.longitude),
        builder: (context) => Container(
          child: GestureDetector(
            onTap: (){
              AlertDialog alertDialog = AlertDialog(
                title: Text(location.title),
                content: Text(location.description),
              );
              showDialog(
                context: context,
                builder: (_) => alertDialog,
              );
            },
            child: Icon(
              Icons.location_on,
              color: Colors.blue,
            )
          ),
        )
      );
      markers.add(auxMarker);
    }
  }
}