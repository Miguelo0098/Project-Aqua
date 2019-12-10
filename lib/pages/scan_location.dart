import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:qrcode_reader/qrcode_reader.dart';


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
      body: new Center(
          child: Text(codebar),
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
    } catch (e) {
      message = "Error: can't parse string to location ($e)";
    }

    _showAlertDialog("Status", message);
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}