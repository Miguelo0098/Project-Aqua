import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class SelectLocationPage extends StatefulWidget {
  SelectLocationPage();

  @override 
  State<StatefulWidget> createState(){
    return SelectLocationPageState();
  }
}

class SelectLocationPageState extends State<SelectLocationPage> {
  // ADD THIS
  MapController mapController = MapController();
  // ADD THIS
  List<Marker> markers = [];
  List<Marker> locationMarkers = [];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Select Location"),),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Tap on the map to select a location',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Flexible(
                child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(0, 0),
                      zoom: 15.0,
                      onTap: moveToLastScreen,
                      plugins: [
                        UserLocationPlugin(),
                      ],
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        tileProvider: NetworkTileProvider()
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
    );
  }

  void moveToLastScreen(LatLng latlng){
    Navigator.pop(context, latlng);
  }
}
