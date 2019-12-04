import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';
import 'package:sqflite/sqflite.dart';

class ListDetails extends StatefulWidget {
  final String appBarTitle;
  final ListClass listClass;

  ListDetails(this.listClass, this.appBarTitle);

  @override
  _ListDetailsState createState() => _ListDetailsState(this.listClass, this.appBarTitle);
}

class _ListDetailsState extends State<ListDetails>{
  DatabaseHelper databaseHelper = DatabaseHelper();


  String appBarTitle;
  ListClass listClass;
  ListClass activeList;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _ListDetailsState(this.listClass, this.appBarTitle);

  @override 
  Widget build(BuildContext context){
    titleController.text = listClass.title;
    descriptionController.text = listClass.description;
    setActiveList();

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextFormField(
                  controller: titleController,
                  onChanged: (value){
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'My Location List'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (value){
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'My Location List'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: translateInt(this.listClass.active),
                      activeColor: Colors.blue,
                      onChanged: (bool newValue){
                        setState(() {
                          _updateIsActive(newValue);
                        });
                      },
                    ),
                    Text("Mark this list as active"),
                  ],
                )
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
                          'Save',
                          textScaleFactor: 1.5,
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
                          'Delete',
                          textScaleFactor: 1.5,
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
          )
        )
      ),
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void updateTitle(){
    listClass.title = titleController.text;
  }

  int translateBool(bool boolean){
    if (boolean) {
      return 1;
    }
    return 0;
  }

  bool translateInt(int integer){
    if (integer == 1) {
      return true;
    }
    return false;
  }

  void _updateIsActive(bool isActive){
    int active = translateBool(isActive);
    this.listClass.active = active;
  }

  void updateDescription(){
    listClass.description = descriptionController.text;
  }


  void _save() async{

    if (this.activeList != null && listClass.active == 1) {
      this.activeList.active = 0;
      
      await databaseHelper.updateList(this.activeList);
      debugPrint('Previous active list gone!');
    }

    moveToLastScreen();
    
    int result;
    if (listClass.id != null) {
      result = await databaseHelper.updateList(listClass);
      
    } else{
      result = await databaseHelper.insertList(listClass);
    }

    if (result == 0) {
      _showAlertDialog('Status', 'Error Saving List');
    }
  }

  void _delete() async{
    moveToLastScreen();

    if (listClass.id == null) {
      _showAlertDialog('Status', 'No List was deleted');
      return;
    }
      
    
    int result = await databaseHelper.deleteList(listClass.id);
    if (result == 0) {
      _showAlertDialog('Status', 'Error Ocurred while Deleting List');
    }
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
}