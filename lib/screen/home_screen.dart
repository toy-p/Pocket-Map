import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:my_tiny_map/screen/add_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          //floatingButtonCustom(Icon(Icons.gps_fixed), 0.4),
          floatingButtonCustom(Icon(Icons.reorder), 0.2,context),
          floatingButtonCustom(
              Icon(Icons.add_location_alt_outlined), 0.0, context),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------- /

  Widget floatingButtonCustom(Icon icon, double val, context) {
    return Align(
      alignment:
          Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - val),
      child: FloatingActionButton(
        onPressed: () {
          if (val == 0.0) {
            _showBottom(context);
          }
          else if(val == 0.2){
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Memory_add())));
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
              offset: Offset(0, 3),
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

  // 퓨즈님 코드 //

  Future _showBottom(context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 15),
              const Divider(thickness: 1, color: Colors.grey),
              _body(context),
            ],
          ),
        );
      },
    );
  }

  Widget _header(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '추억 보기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  _showDialog(context);
                },
                child: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            '마커 제목',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.location_searching),
                SizedBox(width: 10),
                Text('주소가 입력되지 않았습니다.')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _body(context) {
    var itemCount = 4;

    return Expanded(
      child: itemCount > 0
          ? ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 일자 + (수정 및 삭제)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '2023년 04월 23일',
                            style: TextStyle(fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              _showDialog(context);
                            },
                            child: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 갤러리 사진
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2023/05/15/14/35/cat-7995231_1280.jpg',
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                          '고양이는 고양이과 동물 중 하나로, 송곳니를 가지고 태어납니다. 귀여운 동물 중 하나로'),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                '아직 이곳엔 추억이 없어요.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }

  Future _showDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('수정하기'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 10),
                    Text('삭제하기'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 퓨즈님 코드 끝 //
}
