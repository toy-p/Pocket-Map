import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

late KakaoMapController mapController;

KakaoMap map(context) {
  return KakaoMap(
    onMapCreated: (controller) async {
      mapController = controller;
    },
    onMarkerTap: ((markerId, latLng, zoomLevel) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('마커의 위도와 경도는 :\n\n$latLng')));
    }),
  );
}

void getLocation() async {
  await Geolocator.requestPermission(); // 사용자의 위치 권한 요청
  Position position = await Geolocator.getCurrentPosition(
    // 사용자의 위치를 가져옴
    // position.latitude , position.longitude 각각의 값으로 가져올 수 있음
    desiredAccuracy: LocationAccuracy.high,
  );
  mapController.setCenter(LatLng(position.latitude, position.longitude));
  print(
    '현재 위도 : ${position.latitude} & 경도 : ${position.longitude}',
  );
}
