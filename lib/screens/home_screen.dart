import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:my_tiny_map/utils/add_memory.dart';
import 'package:my_tiny_map/utils/show_all_memory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print('테스트용~~');

    // 네이버 지도 초기 설정
    const NaverMapViewOptions(
      initialCameraPosition: NCameraPosition(
        target: NLatLng(107, 114),
        zoom: 1,
        bearing: 0,
        tilt: 0,
      ),
      locationButtonEnable: true,
      mapType: NMapType.navi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          '모든 카테고리',
          style: TextStyle(
            color: Colors.brown[400],
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber[100],
      ),
      body: Stack(
        children: [
          mainMap(),
          searchBar(),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          floatingButtonCustom(const Icon(Icons.add_location_alt_outlined), 0.0,
              context, 'addLocation'),
          floatingButtonCustom(
              const Icon(Icons.reorder), 0.2, context, 'showMemory'),
        ],
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
            dialogBuilder(context);
          } else if (val == 0.2) {
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

  Widget mainMap() {
    return NaverMap(
      options: const NaverMapViewOptions(locationButtonEnable: true),
      onMapReady: (controller) {

        //* 아직 미완성 부분 * (테스트 중) //

        var marker = NMarker(
          id: 'test',
          position: const NLatLng(37.506932467450326, 127.05578661133796),
        );

        controller.addOverlay(marker); // 지도에 마커 추가

        var onMarkerInfoWindow =
            NInfoWindow.onMarker(id: marker.info.id, text: '인포윈도우 텍스트');

        marker.openInfoWindow(onMarkerInfoWindow); // 마커에 내용 추가
      },
    );
  }

  Widget searchBar() {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색할 내용을 입력해주세요.',
                    labelStyle: TextStyle(color: Colors.redAccent),
                    border: InputBorder.none, // 밑줄 없애기
                    focusedBorder: InputBorder.none, // 포커스 되었을때 밑줄 안뜨게
                    prefixIcon: Icon(Icons.search),
                    suffix: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
