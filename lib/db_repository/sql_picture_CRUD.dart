import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';

class SqlPictureCRUD {
  //삽입
  Future<int> picutreModelInsert(PictureModel pictureModel) async {
    var db = await SqlDataBase.instance.database;
    var newRow = pictureModel.toMap();

    var id = await db.insert('picture', newRow);
    return id;
  }

  Future<void> picutreModelUpdate(PictureModel pictureModel) async {
    var db = await SqlDataBase.instance.database;
    await db.update('picture', pictureModel.toMap(),
        where: 'idx = ?', whereArgs: [pictureModel.idx]);
  }

  Future<void> picutreModelDelete(int idx) async {
    var db = await SqlDataBase.instance.database;
    await db.delete('picture', where: 'idx = ?', whereArgs: [idx]);
  }

  Future<List<PictureModel>> fetchPicutres() async {
    var db = await SqlDataBase.instance.database;
    var result = await db.query('picture');
    return result.map((row) => PictureModel.fromMap(row)).toList();
  }

  Future<PictureModel> insert(PictureModel picture) async {
    var db = await SqlDataBase.instance.database;
    picture.idx = await db.insert('picture', picture.toMap());
    return picture;
  }

  Future<List<Map>> loadPictureAll(int markerIdx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM picture WHERE marker_idx =? ', [markerIdx]);
    return result;
  }

  //gridview에서 선택된 index의 MemoryDataMap에서 정보들을 토대로 인자 할당하면 됨.
  Future<List<Map>> loadPicture(int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db
        .rawQuery('SELECT * FROM picture WHERE memory_idx =? ', [memoryIdx]);
    return result;
  }

  // memoryIdx에 해당하는 모든 picture 컬럼 값을 반환하는 함수입니다.
  Future<List<Map>> loadOnlyPicture(int memoryIdx) async {
    // 데이터베이스 인스턴스를 가져옵니다.
    var db = await SqlDataBase.instance.database;

    // memory_idx 값으로 picture 테이블에서 picture 컬럼을 선택합니다.
    List<Map> result = await db.rawQuery(
        'SELECT picture FROM picture WHERE memory_idx =? ', [memoryIdx]);

    // 반환된 결과를 반환합니다.
    return result;
  }

  Future<int> countPicture(int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT picture FROM picture WHERE memory_idx =? ', [memoryIdx]);
    return result.length;
  }

  //하나의 추억에 속한 이미지 지울때
  void deletePicture(int pictureIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM picture WHERE idx = ?', [pictureIdx]);
  }

  //마커에서 추억을 지울때
  void deleteMemoryPicture(int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM picture WHERE memory_idx =? ', [memoryIdx]);
  }

  //마커를 지울때
  void deleteMarkerPicture(int markerIdx) async {
    var db = await SqlDataBase.instance.database;
    await db
        .rawDelete('DELETE FROM picture WHERE marker_idx = ? ', [markerIdx]);
  }
}
