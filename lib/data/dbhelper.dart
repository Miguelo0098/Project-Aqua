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

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'aqua.db';

    var aquaDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return aquaDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = 'CREATE TABLE $locationTable($colIdLocation INTEGER PRIMARY KEY, $colIdList INTEGER, $colTitle TEXT, $colLat NUMBER, $colLong NUMBER, $colDescription TEXT, FOREIGN KEY ($colIdList) REFERENCES $listTable($colIdList))';
    await db.execute(sql);
    sql = 'CREATE TABLE $listTable($colIdList INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT)';
    await db.execute(sql);
  }

  Future<List<Map<String, dynamic>>> getLocationList(int idList) async {
    Database db = await this.database;
    String idListString = idList.toString();

    var result = await db.query(locationTable, where: '$colIdList=$idListString', orderBy: '$colTitle ASC');
  }
}