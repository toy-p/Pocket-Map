import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/db_repository/sql_picture_CRUD.dart';

class PictureProvider extends ChangeNotifier {
  final SqlPictureCRUD _sqlPictureCRUD = SqlPictureCRUD();

  List<PictureModel> _pictures = [];

  List<PictureModel> get pictrues => _pictures;

  Future<int> addPicture(PictureModel pictureModel) async {
    var newPicureIdx = await _sqlPictureCRUD.picutreModelInsert(pictureModel);
    pictureModel.idx = newPicureIdx;

    debugPrint(
        'picutre 생성완료 #${pictureModel.idx}, ${pictureModel.memory_idx}, ${pictureModel.picture} picutre 생성완료');

    _pictures.add(pictureModel);
    notifyListeners();
    return newPicureIdx;
  }

  Future<void> updatePicutre(PictureModel pictureModel) async {
    await _sqlPictureCRUD.picutreModelUpdate(pictureModel);
    _pictures[_pictures.indexWhere(
        (element) => element.idx == pictureModel.idx)] = pictureModel;
    notifyListeners();
  }

  Future<void> deletePicutre(int idx) async {
    await _sqlPictureCRUD.picutreModelDelete(idx);
    _pictures.removeWhere((element) => element.idx == idx);
    notifyListeners();
  }

  Future<void> fetchPicutre() async {
    _pictures = await _sqlPictureCRUD.fetchPicutres();
    notifyListeners();
  }

  List<PictureModel> getPictures(int memoryIdx) {
    var pictureModelList =
        _pictures.where((element) => element.idx == memoryIdx).toList();

    return pictureModelList;
  }
}
