// ignore_for_file: omit_local_variable_types, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kpostal/kpostal.dart';
import 'package:my_tiny_map/utils/add_memory.dart';
import 'package:my_tiny_map/utils/show_all_memory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //String postCode = '-';
  String roadAddress = '-';
  //String jibunAddress = '-';
  String latitude = '-';
  String longitude = '-';
  //String kakaoLatitude = '-';
  //String kakaoLongitude = '-';
  double _latitude = 0.0;
  double _longitude = 0.0;

  late KakaoMapController mapController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '모든 카테고리',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.brown[400],
              fontSize: 25.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[100],
      ),
      body: Stack(
        children: [
          map(),
          searchBar(),
          circleDot(),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          floatingButtonCustom(
            const Icon(Icons.gps_fixed_rounded),
            0.0,
            context,
            'getLocation',
          ),
          floatingButtonCustom(
            const Icon(Icons.add_location_alt_outlined),
            0.2,
            context,
            'addLocation',
          ),
          floatingButtonCustom(
            const Icon(Icons.reorder),
            0.4,
            context,
            'showMemory',
          ),
        ],
      ),
    );
  }

  Widget circleDot() {
    return Center(
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Colors.blue[500],
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget floatingButtonCustom(Icon icon, double val, context, String heroTag) {
    return Align(
      alignment:
          Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - val),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          if (val == 0.0) {
            getLocation();
          } else if (val == 0.2) {
            dialogBuilder(context);
            // showBottom(context); // 해당 위치 마커 추억 보기
          } else if (val == 0.4) {
            bottomSheetBuilder(context);
            // showBottom(context); // 해당 위치 마커 추억 보기
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: icon,
      ),
    );
  }

  KakaoMap map() {
    return KakaoMap(
      onMapCreated: (controller) {
        mapController = controller;
      },
    );
  }

  Future onTap() async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: true,
          localPort: 1024,
          //kakaoKey: 'f4f4541d62360e83a055df52209d4e2',
          callback: (Kpostal result) {
            setState(() {
              //postCode = result.postCode;
              roadAddress = result.address;
              //jibunAddress = result.jibunAddress;
              latitude = result.latitude.toString();
              longitude = result.longitude.toString();
              _latitude = double.parse(latitude);
              _longitude = double.parse(longitude);
              //kakaoLatitude = result.kakaoLatitude.toString();
              //kakaoLongitude = result.kakaoLongitude.toString();
            });
          },
        ),
      ),
    );
  }

  Future moveLocation() async {
    // 딜레이가 없으면 검색된 위도,경도의 값이 반영되지 않아 검색 후 딜레이를 주어서 반영되게 함
    await Future.delayed(const Duration(milliseconds: 8000), () {
      print('검색된 위도 : $_latitude & 경도 : $_longitude');
      mapController.setCenter(LatLng(_latitude, _longitude));
    });
  }

  Widget searchBar() {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: GestureDetector(
        onTap: () {
          onTap();
          moveLocation();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.3),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 12),
                      roadAddress != '-'
                          ? Text(
                              roadAddress,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey.shade800,
                              ),
                            )
                          : Text(
                              '검색할 내용을 입력해주세요.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16.0,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
