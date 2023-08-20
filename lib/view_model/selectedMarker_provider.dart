import 'package:flutter/cupertino.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/db_repository/sql_memory_CRUD.dart';
import 'package:my_tiny_map/db_repository/sql_picture_CRUD.dart';

class SelectedMarkerProvider with ChangeNotifier {
  MarkerModel? _marker;
  MarkerModel? get marker => _marker;
  List<MemoryModel> memories = [];
  List<PictureModel> pictures = [];
  bool isLoading = false;
  Future<void> getMemoryInfo(MarkerModel marker) async {
    debugPrint('getMemory 의 makerid 는 ${marker.id} 입니다.');
    var memoryMaps = await SqlMemoryCRUD().MemoryDataMap(marker.id!);

    for (var i = 0; i < memoryMaps.length; i++) {
      var memoryInstance = MemoryModel.fromMap(memoryMaps[i]);
      debugPrint('${memoryInstance.toMap()}');
      memories.add(memoryInstance);
    }
  }

  Future<void> getPictureInfo(int memoryIdx) async {
    var pictureMaps = await SqlPictureCRUD().loadPicture(memoryIdx);
    for (var i = 0; i < pictureMaps.length; i++) {
      pictures.add(PictureModel.fromMap(pictureMaps[i]));
    }
  }

  Future<void> setInfo(MarkerModel marker) async {
    isLoading = true;
    notifyListeners();
    _marker = marker;
    _marker!.picture;
    memories = [];
    pictures = [];

    await getMemoryInfo(_marker!);
    for (var i = 0; i < memories.length; i++) {
      await getPictureInfo(memories[i].idx!);
    }
    debugPrint('동기화완료');
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    memories = [];
    pictures = [];
    await getMemoryInfo(_marker!);
    for (var i = 0; i < memories.length; i++) {
      await getPictureInfo(memories[i].idx!);
    }
    debugPrint('동기화완료');
    isLoading = false;
    notifyListeners();
  }

  List<PictureModel> searchPictures(int memoryIdx) {
    var picturesAtMemoryIdx = <PictureModel>[];
    for (var i = 0; i < pictures.length; i++) {
      if (pictures[i].memory_idx == memoryIdx) {
        picturesAtMemoryIdx.add(pictures[i]);
      }
    }
    return picturesAtMemoryIdx;
  }

  void initSelectedMarker() {
    _marker = null;
  }
}
