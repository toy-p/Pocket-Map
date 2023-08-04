import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//마커 선택되었을 때, 필요한 모든 정보들
class MarkerSelected with ChangeNotifier{
  //마커관련
  late double longi,lati;
  late int marker_idx;
  //마커 제목
  late String marker_name;
  //마커 장소 = place
  late String place;
  late String icon;
  //memory관련
  late int memory_idx;
  late List<Map> memoryInformation;
  late String dateTime;
  //picture관련
  late List<Map> pictureInformation;

  void setLongi(double longi){
    this.longi = longi;
  }
  void setLati(double lati){
    this.lati = lati;
  }
  void setMarkerIdx(int idx){
    marker_idx = idx;
  }
  void setMarkerName(String name){
    this.marker_name = name;
  }
  void setPlace(String place) {
    this.place = place;
  }
  void setIcon(String icon) {
    this.icon = icon;
  }
  void setMemoryIdx(int idx){
    memory_idx = idx;
  }
  void setDateTime(String dateTime){
    this.dateTime = dateTime;
  }
  void setMemoryInformation(List<Map> memoryInformation){
    this.memoryInformation = memoryInformation;
  }
  void setPictureInformation(List<Map> pictureInformation){
    this.pictureInformation = pictureInformation;
  }
}