import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'location_class.dart';

import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String locationTable = 'location_table';
  
  String colTitle = 'title';
  String colLat = 'latitude';
  String colLong = 'longitude';
  String colDescription = 'description';
  String colId = 'id';


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

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'aqua.db';

    var aquaDatabase = await openDatabase(
      path,
      version: 4,
      onCreate: _createDb,
    );

    return aquaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = 'CREATE TABLE $locationTable($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colLat NUMBER, $colLong NUMBER, $colDescription TEXT)';
    await db.execute(sql);
  }

  // LOCATION FUNCTIONS

  Future<List<Map<String, dynamic>>> getLocationMapList() async {
    Database db = await this.database;

    var result = await db.query(locationTable, orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insertLocation(LocationClass location) async{
    Database db = await this.database;

    var result = await db.insert(locationTable, location.toMap());
    return result;
  }

  Future<int> updateLocation(LocationClass location) async{
    var db = await this.database;
    var result = await db.update(
      locationTable, 
      location.toMap(), 
      where: '$colId = ?',
      whereArgs: [location.id]
    );
    return result;
  }

  Future<int> deleteLocation(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $locationTable WHERE $colId = $id');
    return result;
  }

  Future<int> getLocationCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $locationTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<LocationClass>> getLocationList() async{
    var locationMapList = await getLocationMapList();
    int count = locationMapList.length;

    List<LocationClass> locationList = List<LocationClass>();
    for (int i = 0; i < count; i++) {
      locationList.add(LocationClass.fromMapObject(locationMapList[i]));
    }

    return locationList;
  }

}