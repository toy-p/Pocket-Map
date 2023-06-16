  import 'package:flutter/material.dart';

Future showBottom(context) {
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
