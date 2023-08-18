import 'package:flutter/cupertino.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';

class SqlMemoryCRUD {
  Future<int> memoryModelInsert(MemoryModel memory) async {
    var db = await SqlDataBase.instance.database;
    var newRow = memory.toMap();

    var id = await db.insert('memory', newRow);
    return id;
  }

  Future<void> memoryModelUpdate(MemoryModel memory) async {
    var db = await SqlDataBase.instance.database;
    await db.update('memory', memory.toMap(),
        where: 'idx = ?', whereArgs: [memory.idx]);
  }

  Future<void> memoryModelDelete(int id) async {
    var db = await SqlDataBase.instance.database;
    await db.delete('memory', where: 'idx = ?', whereArgs: [id]);
  }

  Future<List<MemoryModel>> fetchMemorys() async {
    var db = await SqlDataBase.instance.database;
    var result = await db.query('memory');
    return result.map((row) => MemoryModel.fromMap(row)).toList();
  }

  //삽입
  void insert(String contents, String dateTime, int MarkerIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawInsert(
        'INSERT INTO memory(contents,dateTime,marker_idx) VALUES(?,?,?)',
        [contents, dateTime, MarkerIdx]);
  }

  //수정(여기선 content말곤 수정 할 사항 없음)
  //이미지 추가 삭제는 sql_picture_CRUD에서 처리해야함.
  void update(String content, int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawUpdate(
        'UPDATE memory SET contents = ? WHERE idx =? ', [content, memoryIdx]);
  }

  //해당 마커의 추억 리스트.
  Future<List<Map>> MemoryDataMap(int markerIdx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM memory WHERE marker_idx = ? ORDER BY idx', [markerIdx]);

    debugPrint('$result');
    return result;
  }

  ///마커 선택 후 장소등이 저장된 후 memory_idx를 이용하여 제목과 저장 날짜를 알아내는 리스트..? (주로 수정 화면에 사용됨)?
  Future<Map> MemoryDate(int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM memory WHERE idx = ? ORDER BY idx DESC', [memoryIdx]);
    return result[0];
  }

  //마커에 속한 메모리 삭제
  void deleteMemory(int memoryIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM memory WHERE idx = ? ', [memoryIdx]);
  }

  //마커 삭제
  void deleteMarkerMemory(int markerIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM memory WHERE marker_idx = ?', [markerIdx]);
  }
}
