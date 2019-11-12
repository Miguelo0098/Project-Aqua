import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:project_aqua/widgets/drawer.dart';

class AddLocationForm extends StatefulWidget {
  static const String route = '/add_location';
  @override
  _AddLocationFormState createState() => _AddLocationFormState();
}

class _AddLocationFormState extends State<AddLocationForm> {
  final myController = TextEditingController();

  @override 
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Add a Location")),
      drawer: buildDrawer(context, AddLocationForm.route),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(myController.text),
              );
            }
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}