import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDataBase {

  SqlDataBase._instance() {
    _initDataBase();
  }

  factory SqlDataBase() {
    return instance;
  }
  static final SqlDataBase instance = SqlDataBase._instance();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initDataBase();
    return _database!;
  }

  Future<void> _initDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'pocketm.db');
    _database = await openDatabase(path, version: 6, onCreate: _dataBaseCreate);
  }

  void _dataBaseCreate(Database db, int version) async {
    //marker생성
    await db.execute('''
      create table marker (
        id integer primary key autoincrement,
        place text not null,
        lati real not null,
        longi real not null)
      ''');
    //memory생성
    await db.execute('''
      create table memory (
        idx integer primary key autoincrement,
        marker_idx integer not null,
        datetime text not null,
        contents text)
      ''');
    //picture생성
    await db.execute('''
      create table picture (
        idx integer primary key autoincrement,
        marker_idx integer not null,
        memory_idx integer not null,
        picture text)
      ''');
    //DateTime is not a supported SQLite type. Personally I store them as int (millisSinceEpoch) or string (iso8601)
    //bool is not a supported SQLite type. Use INTEGER and 0 and 1 values.
  }

  void closeDataBase() async {
    if (_database != null) await _database!.close();
  }

}