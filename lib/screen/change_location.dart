import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ChangeLocation extends StatelessWidget {
  const ChangeLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 바디부분
      body: Stack(
        children: [
          mainMap(),
          SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: searchBar(),
          ),
        ],
      ),
      // 플러팅액션 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheet(context);
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.check),
      ),
    );
  }

  // ------------------------------------------------------------------------- /

  Widget mainMap() {
    return NaverMap(
      options: const NaverMapViewOptions(),
      onMapReady: (controller) {
        print('네이버맵 로딩 완료!');
      },
    );
  }

  Widget searchBar() {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
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
    );
  }

  Future bottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          
        );
      },
    );
  }
}
