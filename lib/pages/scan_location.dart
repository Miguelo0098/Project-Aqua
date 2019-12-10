import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/home.dart';
import 'package:project_aqua/widgets/drawer.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

import 'add_location.dart';


class ScanLocation extends StatefulWidget {
  static const String route = "/scan";

  @override
  _ScanLocationState createState() => new _ScanLocationState();
}

class _ScanLocationState extends State<ScanLocation> {
  String codebar = "";
  LocationClass location;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Location'),
      ),
      drawer: buildDrawer(context, ScanLocation.route),
      body: new Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Tap the Floating Action Button to scan a QRCode', 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,

              ),
            ),
          )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
        
          Future<String> futurebarcode = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
            futurebarcode.then((barcode){
              setState(() {
                this.codebar = barcode;
                _setLocation();
              });
            });
        },
        tooltip: 'Reader the QRCode',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }


  void _setLocation(){
    String message;
    bool isOk = false;
    try {
      setState(() {
        this.location = LocationClass.fromJson(this.codebar);
      });
      message = "Name: " +
                this.location.title +
                "\nLatitude: " +
                this.location.latitude.toString() +
                "\nLongitude: " +
                this.location.longitude.toString() +
                "\nDescription: " +
                this.location.description;
      isOk = true;
    } catch (e) {
      message = "Error: can't parse string to location ($e)";
    }

    _showAlertDialog("Status", message, isOk);
  }

  void _showAlertDialog(String title, String message, bool isOk){

    AlertDialog alertDialog;
    
    if (isOk) {
      alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          RaisedButton(
            child: Text("Save Location", style: TextStyle(color: Colors.white),),
            onPressed: ()async{
              bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
                return AddLocationForm('Add Location', this.location);
              }));
              if (result == true) {
                Navigator.pushReplacementNamed(context, HomePage.route);
              }

            },
          )
        ],
      );
    } else {
      alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
      );
    }

    
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}