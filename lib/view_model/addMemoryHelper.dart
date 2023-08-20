import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/utils/date.dart';

class AddMemoryHepler {
  String contents = '';
  String dateTime = getToday();
  int? Memory_idx;
  MarkerModel? marker;
  List<String> imgStringList = [];
  List<PictureModel> newPictures = [];

  /// AddMemoryHepler 에 저장한 객체들로 새로운 MemoryModel 을 만듭니다.
  MemoryModel getNewMemoeryModel() {
    var memoryModel = MemoryModel(
        datetime: dateTime, marker_idx: marker!.id, contents: contents);
    debugPrint(
        'getNewMemery = ${memoryModel.datetime}, ${memoryModel.marker_idx}, ${memoryModel.contents}');
    return memoryModel;
  }

  ///AddMemoryHepler 에 저장한 객체들로 새로운 PicutreModel를 만들고 SQL 에 저장합니다. 그리고 List<PicutreModel> 를 반환합니다.
  List<PictureModel> getNewPictureModelList(int memoryIdx) {
    var newPictures = <PictureModel>[];
    for (var i = 0; i < imgStringList.length; i++) {
      var newPictureModel =
          PictureModel(memory_idx: memoryIdx, picture: imgStringList[i]);

      newPictures.add(newPictureModel);
    }

    return newPictures;
  }
}
