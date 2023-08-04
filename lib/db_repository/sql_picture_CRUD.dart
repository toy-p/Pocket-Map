
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_model/picture.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';

class SqlPictureCRUD {

  //삽입
  Future<Picture> insert(Picture picture) async {
    var db = await SqlDataBase.instance.database;
    picture.idx = await db?.insert('picture', picture.toMap());
    return picture;
  }

  Future<List<Map>> loadPictureAll(int marker_idx) async{
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
      'SELECT * FROM picture WHERE marker_idx =? ',[marker_idx]
    );
    return result;
  }
  //gridview에서 선택된 index의 MemoryDataMap에서 정보들을 토대로 인자 할당하면 됨.
  Future<List<Map>> loadPicture(int memory_idx) async{
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT idx,picture FROM picture WHERE memory_idx =? ', [memory_idx]);
    return result;
  }

  Future<int> countPicture(int memory_idx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT picture FROM picture WHERE memory_idx =? ', [memory_idx]);
    return result.length;
  }
  //하나의 추억에 속한 이미지 지울때
  void deletePicture(int picture_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM picture WHERE idx = ?',[picture_idx]);
  }
  //마커에서 추억을 지울때
  void deleteMemoryPicture(int memory_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM picture WHERE memory_idx =? ',[memory_idx]);
  }
  //마커를 지울때
  void deleteMarkerPicture(int marker_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM picture WHERE marker_idx = ? ',[marker_idx]);
  }
}