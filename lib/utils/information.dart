import 'package:flutter/cupertino.dart';

//마커 선택되었을 때, 필요한 모든 정보들
class MarkerSelected with ChangeNotifier {
  //마커관련
  late double longi, lati;
  late int marker_idx;
  late List<Map> marker_all;
  //마커 장소 = place
  late String place;
  late String title;
  late String icon;
  //memory관련
  late int memory_idx;
  late List<Map> memoryInformation;
  late String dateTime;
  //picture관련
  late List<Map> pictureInformation;
  late List<List<Map>> show_all_memory;
  //마커 -> memory -> 정보들 (map)
  late List<List<List<String>>> show_all_picture;
  //마커 -> memory -> picture
  void add_show_all_memory(List<List<Map>> aa) {
    show_all_memory = aa;
  }

  void add_show_all_picture(List<List<List<String>>> aa) {
    show_all_picture = aa;
  }

  void setLongi(double longi) {
    this.longi = longi;
  }

  void setLati(double lati) {
    this.lati = lati;
  }

  void setMarkerAll(List<Map> a) {
    marker_all = a;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setMarkerIdx(int idx) {
    marker_idx = idx;
  }

  void setPlace(String place) {
    this.place = place;
  }

  void setIcon(String icon) {
    this.icon = icon;
  }

  void setMemoryIdx(int idx) {
    memory_idx = idx;
  }

  void setDateTime(String dateTime) {
    this.dateTime = dateTime;
  }

  void setMemoryInformation(List<Map> memoryInformation) {
    this.memoryInformation = memoryInformation;
  }

  void setPictureInformation(List<Map> pictureInformation) {
    this.pictureInformation = pictureInformation;
  }
}
