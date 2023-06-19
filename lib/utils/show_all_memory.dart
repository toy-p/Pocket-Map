import 'package:flutter/material.dart';
import 'package:my_tiny_map/config/route.dart';

Future<void> bottomSheetBuilder(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Stack(
          children: [
            const CustomBottomSheet(),
            Positioned(
                right: 16.0,
                bottom: 16.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.addLocation);
                  },
                  child: Image.asset(
                    'assets/images/map_icon.png',
                  ),
                )),
          ],
        );
      });
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '추억 모아 보기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Memory(
              title: '제목',
              location: '인하대학교 공학과',
              dateTime: '2023년 04월 23일',
              images: ['assets/images/cat.png', 'assets/images/cat2.png'],
              content:
                  '식육목(食肉目) 고양이과의 포유류에 속하며, 반려묘 또는 고양이과의 총칭. 한자로는 묘(猫)라 하고, 수고양이를 낭묘(郎猫), 암고양이를 여묘(女猫), 얼룩고양이를 표화묘(豹花猫),')
        ],
      ),
    );
  }
}

class Memory extends StatelessWidget {
  const Memory(
      {Key? key,
      required this.title,
      required this.location,
      required this.dateTime,
      required this.images,
      required this.content})
      : super(key: key);
  final String title;
  final String location;
  final String dateTime;
  final List<String> images;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/Meatballs_menu.png'))
        ],
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            location,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff8D8D8D),
            ),
          )),
      const SizedBox(
        height: 5,
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            dateTime,
            style: const TextStyle(fontSize: 15),
          )),
      const SizedBox(
        height: 5,
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: images.map((image) => buildDataRow(image)).toList(),
            ),
          )),
      Text(
        content,
        softWrap: true,
      ),
    ]);
  }

  Widget buildDataRow(String image) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          image,
          width: 100,
          height: 100,
        ));
  }
}
