import 'dart:io';

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
  
  String colTitle = 'title';
  String colLat = 'latitude';
  String colLong = 'longitude';
  String colActive = 'active';
  String colDescription = 'description';
  String colId = 'id';
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

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'aqua.db';

    var aquaDatabase = await openDatabase(
      path,
      version: 3,
      onCreate: _createDb,
    );

    return aquaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = 'CREATE TABLE $locationTable($colId INTEGER PRIMARY KEY, $colIdList INTEGER, $colTitle TEXT, $colLat NUMBER, $colLong NUMBER, $colDescription TEXT, FOREIGN KEY ($colIdList) REFERENCES $listTable($colId))';
    await db.execute(sql);
    sql = 'CREATE TABLE $listTable($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colActive INTEGER, $colDescription TEXT)';
    await db.execute(sql);
  }

  // LOCATION FUNCTIONS

  Future<List<Map<String, dynamic>>> getLocationMapList(int idList) async {
    Database db = await this.database;

    var result = await db.query(locationTable, where: '$colIdList = ?', whereArgs: [idList], orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insertLocation(LocationClass location, int idList) async{
    Database db = await this.database;
    location.idList = idList;
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

  Future<int> getLocationCount(int idList) async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $locationTable WHERE $colIdList = $idList');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<LocationClass>> getLocationList(int idList) async{
    var locationMapList = await getLocationMapList(idList);
    int count = locationMapList.length;

    List<LocationClass> locationList = List<LocationClass>();
    for (int i = 0; i < count; i++) {
      locationList.add(LocationClass.fromMapObject(locationMapList[i]));
    }

    return locationList;
  }

  // LIST FUNCTIONS

  Future<List<Map<String, dynamic>>> getListMapList() async{
    Database db = await this.database;
    
    var result = await db.query(listTable, orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insertList(ListClass list) async{
    Database db = await this.database;

    var result = await db.insert(listTable, list.toMap());
    return result;
  }

  Future<int> updateList(ListClass list) async{
    var db = await this.database;
    var result = await db.update(
      listTable, 
      list.toMap(), 
      where: '$colId = ?',
      whereArgs: [list.id]
    );
    return result;
  }

  Future<int> deleteList(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $listTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCountList() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $listTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<ListClass>> getListList() async{
    var ideaMapList = await getListMapList();
    int count = ideaMapList.length;

    List<ListClass> listList = List<ListClass>();
    for (int i = 0; i < count; i++) {
      listList.add(ListClass.fromMapObject(ideaMapList[i]));
    }

    return listList;
  }

  Future<ListClass> getActiveList() async{
    List<ListClass> listList = await getListList();
    if (listList.length != 0 || listList != null) {
      for (var list in listList) {
        if (list.active == 1) {
          return list;
        }
      }
    }
    
    return null;
  }

}