import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'location_class.dart';
import 'list_class.dart';

import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String locationTable = 'location_table';
  String listTable = 'list_table';
  String locationListTable = 'location_list_table';
  
  String colId = 'id';
  String colTitle = 'title';
  String colLat = 'latitude';
  String colLong = 'longitude';
  String colDescription = 'description';
  String colIdLocation = 'id_location';
  String colIdList = 'id_list';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  
}