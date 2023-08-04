import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:my_tiny_map/screens/edit_location_screen.dart';
import 'package:my_tiny_map/db_model/information.dart';
import 'package:my_tiny_map/utils/address_search.dart';
import 'package:my_tiny_map/utils/show_memory.dart';
import 'package:provider/provider.dart';

import '../db_model/marker.dart';
import '../db_repository/sql_marker_CRUD.dart';
import '../db_repository/sql_memory_CRUD.dart';
import '../db_repository/sql_picture_CRUD.dart';

late KakaoMapController mapController;

KakaoMap map(context) {
  return KakaoMap(
    onMapCreated: (controller) async {
      mapController = controller;
    },
    //마커 선택했을 때
    onMarkerTap: (markerId, latLng, zoomLevel) async {

      /*ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('마커의 위도와 경도는 :\n\n$latLng')));*/
      //모든 information 정보 저장하기.
      double _a = double.parse(latLng.latitude.toStringAsFixed(6));
      double _b = double.parse(latLng.longitude.toStringAsFixed(6));
      Provider.of<MarkerSelected>(context, listen:false).setLati(_a);
      Provider.of<MarkerSelected>(context, listen:false).setLongi(_b);
      //마커 선택 시 저장했던 추억들
      Provider.of<MarkerSelected>(context, listen:false).setMemoryInformation(
        await SqlMemoryCRUD().MemoryDataMap(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
      );
      Provider.of<MarkerSelected>(context, listen:false).setPlace('마커 제목');
      //마커 선택 시 모든 추억에 모든 picture정보
      Provider.of<MarkerSelected>(context,listen:false).setPictureInformation(
        await SqlPictureCRUD().loadPictureAll(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
      );
      debugPrint("야 이거다 이거다");
      debugPrint(Provider.of<MarkerSelected>(context,listen:false).pictureInformation.toString());
      //마커에 따른 추억들의 모든 사진들 정보 -> 추후에 pictureInformation의 memory_idx로 찾을수있음. for문 이용.
      debugPrint(latLng.toString());
      debugPrint(Provider.of<MarkerSelected>(context,listen:false).place);
      await showBottom(context);
    },
  );
}

void getLocation(context) async {
  await Geolocator.requestPermission(); // 사용자의 위치 권한 요청
  Position position = await Geolocator.getCurrentPosition(
    // 사용자의 위치를 가져옴
    // position.latitude , position.longitude 각각의 값으로 가져올 수 있음
    desiredAccuracy: LocationAccuracy.high,
  );
  //현재 내 위치 눌렀을 때, 추가와 동시에 마커 찍어버리기
  Set<Marker> mama = {};
  Marker marker = new Marker(
    markerId: "1",
    latLng: LatLng(position.latitude, position.longitude),
    width: 30,
    height: 44,
    offsetX: 15,
    offsetY: 44,
  );
  mama.add(marker);
  mapController.addMarker(markers: mama.toList());
  //내 위치 누르는 버튼 누르면 바로 marker추가하고, 마커와 관련된 정보들 다 저장함.
  //provider로 모두 처리해야함.
  double _a = double.parse(position.latitude.toStringAsFixed(6));
  double _b = double.parse(position.longitude.toStringAsFixed(6));
  //내 위치 눌럿을때 같은 위치인지 확인.
  SqlMarkerCRUD().insert('우리집',_a,_b);
  Provider.of<MarkerSelected>(context, listen:false).setMarkerName('우리집');
  Provider.of<MarkerSelected>(context, listen:false).setLati(_a);
  Provider.of<MarkerSelected>(context, listen:false).setLongi(_b);
  Provider.of<MarkerSelected>(context, listen:false).setMarkerIdx(await SqlMarkerCRUD().MarkerId(_a,_b));
  print(Provider.of<MarkerSelected>(context, listen:false).marker_idx);
  debugPrint((await SqlMarkerCRUD().MarkerInformation(_a,_b)).toString());
  //memory_idx는 마커 선택했을때, 수정하기 눌럿을때 or 추억 생성 순간에 결정해줌.
  mapController.setCenter(LatLng(position.latitude, position.longitude));
  print(
    '현재 위도 : ${position.latitude} & 경도 : ${position.longitude}',
  );
}
