import 'package:flutter/material.dart';

/// 마커 추가
Future<void> dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return const CustomDialog();
    },
  );
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 300,
          minHeight: 400,
          maxHeight: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _inputTitle(),
              _place(),
              _iconMarker(),
              _custormMarker(),
              _preViewMarker(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _header(context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.clear), splashRadius: 15,),
        const Text('마커 수정', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20), ),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text('저장', style: TextStyle(color: Colors.black)
          ,))
      ],
    ),
  );
}

Widget _inputTitle() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      children: [
        const Text('제목'),
        const SizedBox(width: 8,),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffEFC903),
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 3, top: 6),
            margin: const EdgeInsets.only(right: 20),

            child: const TextField(
              decoration: null,
            ),
          ),
        ),



      ],
    ),
  );
}

Widget _place() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      children: [
        const Text('장소'),
        const SizedBox(width: 8,),
        TextButton(onPressed: (){}, child: const Text('인하대학교 경영대학', style: TextStyle(color: Colors.black),))
      ],
    ),
  );
}

Widget _iconMarker() {
  var iconList = <IconData>[
    Icons.movie_outlined,
    Icons.dinner_dining_outlined,
    Icons.school_outlined,
    Icons.subway_outlined
  ];
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('기본마커'),
        const SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                for (int i = 0; i < iconList.length; i++)
                  IconButton(
                    onPressed: () {},
                    iconSize: 20,
                    icon: Icon(iconList[i]),
                    splashRadius: 15,
                  )
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _custormMarker() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('커스텀 마커'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 0, height: 0,),
            IconButton(onPressed: () {},iconSize: 20, icon: const Icon(Icons.add_photo_alternate_outlined),splashRadius: 15,),
          ],
        ),
      ],
    ),
  );
}

Widget _preViewMarker() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text('마커 미리보기'),
        const SizedBox(height: 30,),
        Center(

          child:  Container(constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 80,
          ),
            child: ClipRRect(

                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset('assets/images/cat.png')// Text(key['title']),
            ),
          ),
        )],
    ),
  );
}