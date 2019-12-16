import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/location_class.dart';
import 'package:project_aqua/pages/select_location.dart';
import 'package:project_aqua/widgets/drawer.dart';
import 'package:latlong/latlong.dart';

class AddLocationForm extends StatefulWidget {
  static const String route = '/add_location';

  final String appBarTitle;
  final LocationClass locationClass;

  AddLocationForm(this.appBarTitle, this.locationClass);

  @override
  _AddLocationFormState createState() => _AddLocationFormState(this.appBarTitle, this.locationClass);
}

class _AddLocationFormState extends State<AddLocationForm> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  LocationClass locationClass;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _AddLocationFormState(this.appBarTitle, this.locationClass);

  @override 
  Widget build(BuildContext context){

    titleController.text = locationClass.title;
    descriptionController.text = locationClass.description; 

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
                controller: titleController,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  updateTitle();
                },
                decoration: InputDecoration(
                  hintText: 'Fountain near home',
                  labelText: 'Name'
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.cyan,
                        textColor: Colors.white,
                        child: Text(
                          'Set Coordinates',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: (){
                          setState(() {
                            setLocation();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  updateDescription();
                },
                decoration: InputDecoration(
                  hintText: 'A fountain near my home. Water is OK',
                  labelText: 'Description'
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        child: Text(
                          'Save Location',
                          textScaleFactor: 1.2,
                        ),
                        onPressed: (){
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(width: 5.0,),

                    Expanded(
                      child: RaisedButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text(
                          'Delete Location',
                          textScaleFactor: 1.2,
                        ),
                        onPressed: (){
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void setLocation() async {
    LatLng location = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return SelectLocationPage();
    }));
    if (location != null) {
      locationClass.latitude = location.latitude;
      locationClass.longitude = location.longitude;
      String message = 'Coordinates set to Lat: '+ locationClass.latitude.toString() + ' Long: ' + locationClass.longitude.toString();
      _showAlertDialog('Status', message);
    }
  }

  void updateTitle(){
    locationClass.title = titleController.text;
  }

  void updateDescription(){
    locationClass.description = descriptionController.text;
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

  void _save()async{
    goHome();
    int result;
    if (locationClass.id != null) {
      result = await helper.updateLocation(locationClass);
      debugPrint('Actualizado!');
      
    } else{
      result = await helper.insertLocation(locationClass);
    }

    if (result == 0) {
      _showAlertDialog('Status', 'Error Saving Location');
    }else{
      String message = 'Location Saved successfully\nLatitude: ' 
        + locationClass.latitude.toString()
        + '\nLongitude: '
        + locationClass.longitude.toString();
      _showAlertDialog('Status', message);
    }
  }

  void _delete() async{
    goHome();
    if (locationClass.id == null) {
      _showAlertDialog('Status', 'No Idea was deleted');
      return;
    }
      
    
    int result = await helper.deleteLocation(locationClass.id);
    if (result == 0) {
      _showAlertDialog('Status', 'Error Ocurred while Deleting Idea');
    }
  }

  void goHome(){
    Navigator.pop(context, true);
  }

}