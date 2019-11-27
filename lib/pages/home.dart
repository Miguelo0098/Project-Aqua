import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:project_aqua/pages/add_location.dart';
import 'package:user_location/user_location.dart';
import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';
  // ADD THIS
  MapController mapController = MapController();
  // ADD THIS
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Street Map"),),
      drawer: buildDrawer(context, route),
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
                  zoom: 5.0,
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
            MaterialPageRoute(builder: (context) => AddLocationForm())
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_location),
      ),
    );
  }
}