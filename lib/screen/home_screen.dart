import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 부분
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
      // 바디부분
      body: Stack(
        children: [
          mainMap(),
          searchBar(),
        ],
      ),
      // 플러팅액션 버튼
      floatingActionButton: Stack(
        children: [
          floatingButtonCustom(Icon(Icons.gps_fixed), 0.4),
          floatingButtonCustom(Icon(Icons.reorder), 0.2),
          floatingButtonCustom(Icon(Icons.add_location_alt_outlined), 0.0),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------- /

  // function
  Widget floatingButtonCustom(Icon icon, double val) {
    return Align(
      alignment:
          Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - val),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: icon,
      ),
    );
  }

  Widget mainMap() {
    return NaverMap(
      options: const NaverMapViewOptions(),
      onMapReady: (controller) {
        print('네이버맵 로딩 완료!');
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
              offset: Offset(0,3),
            ),
          ],
        ),
        height: 60,
        //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: const [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색할 내용을 입력해주세요.',
                    //
                    labelStyle: TextStyle(color: Colors.redAccent),
                    //
                    border: InputBorder.none, // 밑줄 없애기
                    focusedBorder: InputBorder.none, // 포커스 되었을때 밑줄 안뜨게
                    //
                    prefixIcon: Icon(Icons.search),
                    suffix: Icon(Icons.close),
                    //
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
