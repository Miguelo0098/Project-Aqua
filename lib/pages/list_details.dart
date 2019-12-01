import 'package:flutter/material.dart';
import 'package:project_aqua/data/dbhelper.dart';
import 'package:project_aqua/data/list_class.dart';

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

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _ListDetailsState(this.listClass, this.appBarTitle);

  @override 
  Widget build(BuildContext context){
    titleController.text = listClass.title;
    descriptionController.text = listClass.description;

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
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
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
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
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

  void updateDescription(){
    listClass.description = descriptionController.text;
  }

  void _save() async{
    moveToLastScreen();

    int result;
    if (listClass.id != null) {
      result = await databaseHelper.updateList(listClass);
      
    } else{
      result = await databaseHelper.insertList(listClass);
    }

    if (result == 0) {
      _showAlertDialog('Status', 'Error Saving Idea');
    }
  }

  void _delete() async{
    moveToLastScreen();

    if (listClass.id == null) {
      _showAlertDialog('Status', 'No Idea was deleted');
      return;
    }
      
    
    int result = await databaseHelper.deleteList(listClass.id);
    if (result == 0) {
      _showAlertDialog('Status', 'Error Ocurred while Deleting Idea');
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
}