import 'package:flutter/cupertino.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/db_repository/sql_memory_CRUD.dart';
import 'package:my_tiny_map/db_repository/sql_picture_CRUD.dart';

class SelectedMemoryProvider with ChangeNotifier {
  MemoryModel? _memory;
  MemoryModel? get memory => _memory;
  List<PictureModel> pictures = [];

  Future<void> setData(MemoryModel memoryModel) async {
    _memory = memoryModel;
    pictures = [];

    var memoryMap = await SqlMemoryCRUD().MemoryDate(memoryModel.idx!);
    _memory = MemoryModel.fromMap(memoryMap);
    var pictureMaps = await SqlPictureCRUD().loadPicture(memoryModel.idx!);
    for (var i = 0; i < pictureMaps.length; i++) {
      pictures.add(PictureModel.fromMap(pictureMaps[i]));
    }

    notifyListeners();
  }

  //만약 picutres 가 바뀌면 바뀐 부분을
  //그냥 추가하면 추가하고 지우면 지우면 될 것같다.

  void addPicture(PictureModel pictureModel) {
    pictures.add(pictureModel);
    notifyListeners();
  }

  Future<void> deletePicutre(int idx) async {
    pictures.removeWhere((element) => element.idx == idx);
    notifyListeners();
  }

  void initSelectedMemory() {
    _memory = null;
  }
}
