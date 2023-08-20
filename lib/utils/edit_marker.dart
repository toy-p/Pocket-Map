import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kpostal/kpostal.dart';
import 'package:my_tiny_map/datas/models/kakaomap_model.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/utils/image_utility/utility.dart';
import 'package:my_tiny_map/utils/kakao.dart';
import 'package:my_tiny_map/utils/show_memory.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:my_tiny_map/view_model/selectedMarker_provider.dart';
import 'package:provider/provider.dart';

Future<void> EditMarker(BuildContext context) async {
  var markerProvider = context.read<SelectedMarkerProvider>();
  var marker = markerProvider.marker; // 선택된 마커
  print(marker!.toMap());
  return showDialog<void>(
    context: context,
    builder: (context) {
      return CustomDialog(marker: marker);
    },
  );
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key, required this.marker});
  final MarkerModel marker;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  void initState() {
    super.initState();

    setData(widget.marker);
  }

  ///처음 원래 마커 정보를 불러오는 함수
  void setData(MarkerModel markerModel) {
    //마커 미리보기 설정
    if (markerModel.picture != null) {
      var picutre = markerModel.picture;
      initImage = Utility.imageFromBase64String(picutre!);
    } else {
      selectIcon =
          IconData(markerModel.icon_codepoint!, fontFamily: 'MaterialIcons');
    }

    //마커의 contents
    _TitleTextEditController.text = markerModel.title;

    //marker 위치
    getL.roadAddress = markerModel.place!;
    getL.latitude = markerModel.lati.toString();
    getL.longitude = markerModel.longi.toString();
  }

//마커의 정보들

  GetLocation getL = GetLocation();

//마커 미리보기
  final ImagePicker _picker = ImagePicker();
  Image? initImage;
  XFile? _pickedImage;

  String title = '';
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final TextEditingController _TitleTextEditController =
      TextEditingController();
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
      _pickedImage = image;
      selectIcon = null;
      initImage = null;
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
                              _pickedImage = null;
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
                            _pickedImage = null;
                            initImage = null;
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
          if (initImage != null)
            Positioned.fill(child: initImage!)
          else if (_pickedImage != null)
            Center(
                child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ))
          else if (selectIcon != null)
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
            maxWidth: 600,
            minHeight: 400,
            maxHeight: 700,
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
            '수정',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
          TextButton(
              onPressed: () {
                _EditMarkerData(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 100));
                showBottom(widget.marker.id!, context);
              },
              child: const Text(
                '수정하기',
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
              child: TextField(
                controller: _TitleTextEditController,
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
          if (getL.roadAddress == '-')
            TextButton(
                onPressed: () {
                  onTap();
                },
                child: const Text(
                  '장소찾기',
                  style: TextStyle(color: Colors.black),
                ))
          else
            TextButton(
                onPressed: () {
                  onTap();
                },
                child: Text(
                  getL.roadAddress,
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

  Future<void> _EditMarkerData(context) async {
    // Marker 객체를 생성하여 해당 필드 값들을 설정합니다.
    if (_TitleTextEditController.text.isEmpty ||
        (selectIcon == null && (_pickedImage != null || initImage != null)) ||
        getL.roadAddress == '-') {
    } else {
      int? selecticonCodepoint;
      String? picture;
      if (_pickedImage != null) {
        picture = Utility.base64String(await _pickedImage!.readAsBytes());
      } else if (selectIcon != null) {
        selecticonCodepoint = selectIcon!.codePoint;
      } else if (initImage != null) {
        picture = widget.marker.picture;
      } else {
        selecticonCodepoint = null;
      }
      print('마커 수정할게여');
      var newMarker = MarkerModel(
        // 임의로 선택한 id 값 (데이터베이스에서 SQLITE_AUTOINCREMENT로 설정된 경우)
        title: _TitleTextEditController.text, // 제목
        icon_codepoint: selecticonCodepoint,
        picture: picture, // 선택한 아이콘
        lati: double.parse(getL.latitude), // 선택한 사진 (null일 수 있음)
        longi: double.parse(getL.longitude),
        place: getL.roadAddress,
      );

      // sqflite 데이터베이스에 저장하는 함수 호출
      var markerId = Provider.of<SelectedMarkerProvider>(context, listen: false)
          .marker!
          .id;
      newMarker.id = markerId;
      await Provider.of<MarkerProvider>(context, listen: false)
          .updateMarker(newMarker);
      await Provider.of<SelectedMarkerProvider>(context, listen: false)
          .fetchData();
      // 마커 정보를 불러온다.

      // 마커 맵에 불러온 마커를 추가한다.
    }
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

  Future moveLocation() async {
    // 딜레이가 없으면 검색된 위도,경도의 값이 반영되지 않아 검색 후 딜레이를 주어서 반영되게 함
    await Future.delayed(const Duration(milliseconds: 12000), () {
      mapController.setCenter(LatLng(getL.init_latitude, getL.init_longitude));
    });
  }
}
