import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';

class SqlMemoryCRUD {

  //삽입
  void insert(String contents,String dateTime,int MarkerIdx) async {
    var db = await SqlDataBase.instance.database;
    await db.rawInsert(
        'INSERT INTO memory(contents,dateTime,marker_idx) VALUES(?,?,?)',[contents,dateTime,MarkerIdx]);
  }
  //수정(여기선 content말곤 수정 할 사항 없음)
  //이미지 추가 삭제는 sql_picture_CRUD에서 처리해야함.
  void update(String content,int memory_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawUpdate('UPDATE memory SET contents = ? WHERE idx =? ',[content,memory_idx]);
  }
  //해당 마커의 추억 리스트.
  Future<List<Map>> MemoryDataMap(int marker_idx) async{
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
        'SELECT * FROM memory WHERE marker_idx = ? ORDER BY idx', [marker_idx]);
    return result;
  }
  //마커 선택 후 장소등이 저장된 후 memory_idx를 이용하여 제목과 저장 날짜를 알아내는 리스트..? (주로 수정 화면에 사용됨)?
  Future<Map> MemoryDate(int memory_idx) async{
    var db = await SqlDataBase.instance.database;
    List<Map> result = await db.rawQuery(
      'SELECT * FROM memory WHERE idx = ? ORDER BY idx DESC',[memory_idx]
    );
    return result[0];
  }
  //마커에 속한 메모리 삭제
  void deleteMemory(int memory_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM memory WHERE idx = ? ',[memory_idx]);
  }
  //마커 삭제
  void deleteMarkerMemory(int marker_idx) async{
    var db = await SqlDataBase.instance.database;
    await db.rawDelete('DELETE FROM memory WHERE marker_idx = ?',[marker_idx]);
  }
}