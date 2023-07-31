import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';
import 'package:my_tiny_map/datas/models/kakaomap_model.dart';

// 마커 추가
Future<void> dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return const CustomDialog();
    },
  );
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var place = '장소 찾기';
  GetLocation getL = GetLocation();
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImages;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  TextEditingController textController = TextEditingController();
  IconData? selectIcon;
  final List<IconData> iconList = [
    Icons.movie_outlined,
    Icons.dinner_dining_outlined,
    Icons.school_outlined,
    Icons.subway_outlined
  ];

  void getImage(ImageSource source) async {
    var image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImages = image;
      selectIcon = null;
    });
  }

  Widget _iconMarker() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('기본마커'),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (int i = 0; i < iconList.length; i++)
                    if (iconList[i] == selectIcon)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.2, color: Colors.black),
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectIcon = iconList[i];
                              _pickedImages = null;
                            });
                          },
                          iconSize: 20,
                          icon: Icon(iconList[i]),
                          splashRadius: 15,
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectIcon = iconList[i];
                            _pickedImages = null;
                          });
                        },
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

  Widget _preViewMarker() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('마커 미리보기'),
          const SizedBox(
            height: 30,
          ),
          if (_pickedImages == null)
            Center(
                child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Icon(
                    selectIcon,
                    size: 30,
                  )),
            ))
          else
            Center(
                child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: Image.file(
                  File(_pickedImages!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
      ),
    );
  }

  Widget _header(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.clear),
            splashRadius: 15,
          ),
          const Text(
            '마커 추가',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '저장',
                style: TextStyle(color: Colors.black),
              ))
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
          const SizedBox(
            width: 8,
          ),
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
          const SizedBox(
            width: 8,
          ),
          TextButton(
              onPressed: () {
                onTap();
              },
              child: Text(
                place,
                style: const TextStyle(color: Colors.black),
              ))
        ],
      ),
    );
  }

  Future onTap() async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: true,
          localPort: 1024,
          callback: (result) {
            setState(() {
              place = result.address;
              getL.roadAddress = result.address;
              getL.latitude = result.latitude.toString();
              getL.longitude = result.longitude.toString();
              getL.init_latitude = double.parse(getL.latitude);
              getL.init_longitude = double.parse(getL.longitude);
              print(
                  '검색된 위도 : ${getL.init_latitude} & 경도 : ${getL.init_longitude}');
            });
          },
        ),
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
              const SizedBox(
                width: 0,
                height: 0,
              ),
              IconButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                iconSize: 20,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                splashRadius: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
