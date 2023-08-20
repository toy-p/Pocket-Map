import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';

class SqlMarkerCRUD {
  Future<int> markerModelInsert(MarkerModel marker) async {
    var db = await SqlDataBase.instance.database;
    var newRow = marker.toMap();

    var id = await db.insert('marker', newRow);
    return id;
  }

  Future<void> markerModelUpdate(MarkerModel marker) async {
    var db = await SqlDataBase.instance.database;
    await db.update('marker', marker.toMap(),
        where: 'id = ?', whereArgs: [marker.id]);
  }

  Future<void> markerModelDelete(int id) async {
    var db = await SqlDataBase.instance.database;
    await db.delete('marker', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MarkerModel>> fetchMarkers() async {
    var db = await SqlDataBase.instance.database;
    var result = await db.query('marker');
    return result.map((row) => MarkerModel.fromMap(row)).toList();
  }

  void insert(
    String place,
    double lati,
    double longi,
  ) async {
    var db = await SqlDataBase.instance.database;
    await db.rawInsert('INSERT INTO marker(lati,longi,place) VALUES(?,?,?)',
        [place, lati, longi]);
  }

  Future<int> dbInsert(String title, int? iconCodepoint, String? picture,
      double lati, double longi, String? place) async {
    var db = await SqlDataBase.instance.database;
    var newRow = <String, dynamic>{
      'title': title,
      'icon_codepoint': iconCodepoint,
      'picture': picture,
      'lati': lati,
      'longi': longi,
      'place': place
    };
    var newRowId = await db.insert('marker', newRow);
    print(db);
    return newRowId;
  }

  Future<String> MarkerPlace(int id) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result =
        await db.rawQuery('SELECT place FROM marker WHERE id =? ', [id]);
    return result[0]['place'];
  }

  Future<Map<String, dynamic>> getMarkerInformation(int id) async {
    var db = await SqlDataBase.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('marker', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) {
      throw Exception('No marker found with id $id');
    }
    return maps[0];
  }

  //현재 선택한 위도,경도의 markerid값.
  Future<int> MarkerId(double lati, double longi) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT id FROM marker WHERE lati =? AND longi =? ', [lati, longi]);
    return result[0]['id'];
  }

  Future<List<Map>> MarkerInformation(double lati, double longi) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM marker WHERE lati = ? AND longi = ?', [lati, longi]);
    print(result);
    return result;
  }

  //마커 삭제
  void deleteMarker(double lati, double longi) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete(
        'DELETE FROM marker WHERE lati = ? AND longi =? ', [lati, longi]);
  }

  Future<List<Map<String, dynamic>>> getAllMarker() async {
    var db = await SqlDataBase.instance.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM marker');

    return result;
  }

  void deleteMarkerId(int markerIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM marker WHERE id = ?', [markerIdx]);
  }
}
