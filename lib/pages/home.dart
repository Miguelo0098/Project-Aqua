import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/add_location.dart';
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
  List<Marker> locationMarkers = [];

  List<LocationClass> locations;
  int countList = 0;

  @override
  Widget build(BuildContext context){
    
    if (locations == null) {
      locations = List<LocationClass>();
      updateListView();
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
                  MarkerLayerOptions(markers: locationMarkers),
                  
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
          
          navigateToAddForm('Add Location', new LocationClass('', 0, 0, ''));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_location),
      ),
    );
  }


  void navigateToAddForm(String title, LocationClass location)async{
    bool result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => AddLocationForm(title, location)
    ));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<LocationClass>> listLocationFuture = databaseHelper.getLocationList();
      listLocationFuture.then((listLocation){
        setState((){
          this.locations = listLocation;
          this.countList = listLocation.length;
          this.locationMarkers = getMarkers();
        });
      });
    });
  }

  List<Marker> getMarkers(){
    List<Marker> markers = this.locations.map((location){
      return Marker(
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
    }).toList();

    return markers;
  }

}