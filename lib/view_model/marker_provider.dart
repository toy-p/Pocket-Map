import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_repository/sql_marker_CRUD.dart';

class MarkerProvider extends ChangeNotifier {
  final SqlMarkerCRUD _sqlMarkerCRUD = SqlMarkerCRUD();

  List<MarkerModel> _markers = [];

  List<MarkerModel> get markers => _markers;

  MarkerModel? currentMarker;

  void updateCurrentMarker(MarkerModel marker) {
    currentMarker = marker;
    notifyListeners();
  }

  void initCurrentMarker() {
    currentMarker!.place = '-';
    notifyListeners();
  }

  Future<void> addMarker(MarkerModel marker) async {
    marker.id = await _sqlMarkerCRUD.markerModelInsert(marker);
    _markers.add(marker);
    notifyListeners();
  }

  Future<void> updateMarker(MarkerModel marker) async {
    await _sqlMarkerCRUD.markerModelUpdate(marker);
    _markers[_markers.indexWhere((element) => element.id == marker.id)] =
        marker;
    notifyListeners();
  }

  Future<void> deleteMarker(int id) async {
    await _sqlMarkerCRUD.markerModelDelete(id);
    _markers.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> fetchMarkers() async {
    _markers = await _sqlMarkerCRUD.fetchMarkers();
    notifyListeners();
  }

  MarkerModel searchMarker(int markerIdx) {
    //쿼리문을 통해서 memory_idx 인 marker를 찾는다. 아니면 검색한다.
    return _markers[_markers.indexWhere((element) => element.id == markerIdx)];
  }
}
