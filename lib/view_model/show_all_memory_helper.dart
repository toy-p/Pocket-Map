import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_repository/sql_picture_CRUD.dart';

class ShowAllMemoryHelper {
  ShowAllMemoryHelper({required this.memoryModel, required this.markerModel}) {
    place = markerModel.place!;
    contents = memoryModel.contents ?? '';
    datatime = memoryModel.datetime;
  }

  MarkerModel markerModel;
  MemoryModel memoryModel;
  String place = '';
  String contents = '';
  String datatime = '';
  List<String> images = [];

  Future<List<String>> loadPicture(int memoryIdx) async {
    var picture = await SqlPictureCRUD().loadOnlyPicture(memoryIdx);

    for (var i = 0; i < picture.length; i++) {
      String image = picture[i]['picture'];

      images.add(image);
    }

    return images;
  }
}
