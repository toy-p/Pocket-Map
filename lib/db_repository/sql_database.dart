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
    var path = join(databasesPath, 'pocketm.db');

    _database = await openDatabase(
      path,
      version: 21,
      onCreate: _dataBaseCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _dataBaseCreate(Database db, int version) async {
    //marker생성
    await db.execute('''
        create table marker (
          id integer primary key autoincrement,
          lati real not null,
          longi real not null,
          icon_codepoint integer,
          picture text,
          title text not null,
          place text not null)
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
        memory_idx integer not null,
        picture text)
      ''');
    //DateTime is not a supported SQLite type. Personally I store them as int (millisSinceEpoch) or string (iso8601)
    //bool is not a supported SQLite type. Use INTEGER and 0 and 1 values.
  }

  void closeDataBase() async {
    if (_database != null) await _database!.close();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 기존 테이블 삭제 로직을 작성합니다.
    await db.execute('DROP TABLE IF EXISTS marker');
    await db.execute('DROP TABLE IF EXISTS memory');
    await db.execute('DROP TABLE IF EXISTS picture');
    print('resetdatabase');
    // 삭제한 후 새로운 테이블을 생성합니다.
    _dataBaseCreate(db, newVersion);
  }
}
