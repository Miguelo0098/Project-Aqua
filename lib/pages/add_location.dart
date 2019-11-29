import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/widgets/drawer.dart';
import 'package:sqflite/sqflite.dart';

class AddLocationForm extends StatefulWidget {
  static const String route = '/add_location';

  final String appBarTitle;
  final LocationClass location;

  AddLocationForm(this.appBarTitle, this.location);

  @override
  _AddLocationFormState createState() => _AddLocationFormState(this.appBarTitle, this.location);
}

class _AddLocationFormState extends State<AddLocationForm> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  LocationClass location;

  final myController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _AddLocationFormState(this.appBarTitle, this.location);

  @override 
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      drawer: buildDrawer(context, AddLocationForm.route),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Fountain near home',
                  labelText: 'Name'
                )
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: '41.2345123',
                  labelText: 'Latitude'
                )
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: '2.2345123',
                  labelText: 'Longitude'
                )
              ),
              
            ],
          ),
        )
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