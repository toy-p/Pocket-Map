
import 'package:my_tiny_map/db_model/marker.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';
import 'package:sqflite/sqflite.dart';

class SqlMarkerCRUD {

  void insert(String place,double lati,double longi) async {
    var db = await SqlDataBase.instance.database;
    await db.rawInsert(
      'INSERT INTO marker(place,lati,longi) VALUES(?,?,?)',[place,lati,longi]);
  }

  //현재 선택한 위도,경도의 markerid값.
  Future<int> MarkerId(double lati,double longi) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT id FROM marker WHERE lati =? AND longi =? ', [lati,longi]);
    return result[0]['id'];
  }

  Future<List<Map>> MarkerInformation(double lati,double longi) async{
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
      'SELECT * FROM marker WHERE lati = ? AND longi = ?', [lati,longi]);
    return result;
  }

  //마커 삭제
  void deleteMarker(double lati,double longi) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM marker WHERE lati = ? AND longi =? ',[lati,longi]);
  }
}