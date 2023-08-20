import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tiny_map/config/route.dart';
import 'package:my_tiny_map/utils/date.dart';
import 'package:my_tiny_map/utils/image_utility/utility.dart';
import 'package:my_tiny_map/view_model/addMemoryHelper.dart';
import 'package:my_tiny_map/view_model/memory_provider.dart';
import 'package:my_tiny_map/view_model/picture_provider.dart';
import 'package:my_tiny_map/view_model/selectedMarker_provider.dart';
import 'package:provider/provider.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _pickedImages = [];
  List<String> imgStringList = [];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  TextEditingController textController = TextEditingController();

  void popUp(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            '정말 나가시겠어요?',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
          ),
          content: SizedBox(
            height: 95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('작성중인 내용을 임시 저장하거나'),
                const Text('계속 수정할 수 있습니다.'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Text(
                        '나가기',
                        style: TextStyle(
                            color: Colors.deepOrange.shade300,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName(RouteName.home));
                      },
                    ),
                    InkWell(
                      child: Text(
                        '계속 수정',
                        style: TextStyle(
                            color: Colors.deepOrange.shade300,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void getImage(ImageSource source) async {
    var image = await _picker.pickImage(source: source);
    var imgString = Utility.base64String(await image!.readAsBytes());
    imgStringList.add(imgString);
    setState(() {
      _pickedImages.add(image);
    });
  }

  void getMultiImage() async {
    var images = await _picker.pickMultiImage();
    for (var i = 0; i < images.length; i++) {
      var imgString = Utility.base64String(await images[i].readAsBytes());
      imgStringList.add(imgString);
    }
    setState(() {
      _pickedImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    var marker =
        Provider.of<SelectedMarkerProvider>(context, listen: false).marker;
    var markerPlace = marker?.place;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                popUp(context);
              },
              child: const Icon(Icons.keyboard_backspace_outlined,
                  color: Colors.black54)),
          centerTitle: true,
          title: const Text('추억 남기기',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white54,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () {
                saveData(context);
                debugPrint(textController.text);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.white54),
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey.shade200),
                shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)))),
              ),
              child: Text('저장',
                  style: TextStyle(
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          heroTag: 'menu',
          backgroundColor: Colors.white54,
          icon: Icons.add,
          iconTheme: const IconThemeData(color: Colors.black),
          activeIcon: Icons.close,
          elevation: 130,
          spacing: 3,
          direction: SpeedDialDirection.up,
          useRotationAnimation: true,
          //true이면 close버튼을 눌러야만 close할 수 있음.
          closeManually: false,
          //animationDuration: const Duration(milliseconds: 500), // 윈도우에서 에러가 나서 주석처리 하였습니닷
          spaceBetweenChildren: 9.0,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.camera_alt_outlined),
              onTap: () => getImage(ImageSource.camera),
              //label: '카메라',
            ),
            SpeedDialChild(
              child: const Icon(Icons.photo_library_outlined),
              onTap: () => getMultiImage(),
              //label: '갤러리',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('장소', style: TextStyle(fontSize: 15)),
                              SizedBox(height: 10),
                              Text('방문 일자', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(markerPlace!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 10),
                              Text(getToday(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            // 노트 입력
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFF59D),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.text,
                      showCursor: true,
                      maxLines: null,
                      autofocus: false,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: '추억을 남겨보세요.',
                      ),
                    ),
                  )),
            )),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 1, 20, 0),
              child: Divider(thickness: 1, color: Colors.grey),
            ),
            Expanded(child: showImage()),
          ],
        ),
      ),
    );
  }

  Widget _gridPhotoItem(XFile e) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(e.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pickedImages.remove(e);
                });
              },
              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showImage() {
    if (_pickedImages.isEmpty) {
      return Container(
        alignment: const AlignmentDirectional(0.0, 0.0),
        height: 200,
        child: const Text(
          '사진을 추가해 보세요',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 18.0,
          ),
        ),
      );
    } else {
      return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10,
            ),
            itemCount: _pickedImages.length,
            itemBuilder: (context, index) {
              return _gridPhotoItem(_pickedImages[index]!);
            },
          ));
    }
  }

  void saveData(context) async {
    var addMemoryHepler = AddMemoryHepler();
    addMemoryHepler.contents = textController.text;
    debugPrint('----Memory contents -------');
    debugPrint('addMemoryHepler.contents : ${addMemoryHepler.contents}');

    addMemoryHepler.dateTime = getToday();
    debugPrint('----Memory dateTime -------');
    debugPrint('gettoday() : ${addMemoryHepler.dateTime}');
    debugPrint('----MarkerInfo-------');
    addMemoryHepler.marker =
        Provider.of<SelectedMarkerProvider>(context, listen: false).marker;
    debugPrint('${addMemoryHepler.marker!.toMap()}');

    addMemoryHepler.imgStringList.addAll(imgStringList);

    var newMemoryModel = addMemoryHepler.getNewMemoeryModel();
    var newMemoryIdx = await Provider.of<MemoryProvider>(context, listen: false)
        .addMemory(newMemoryModel);
    debugPrint('새롭게 생성한 newMemoryModel 의 idx 는 ${newMemoryModel.idx} 입니다.');
    //새롭게 생성한 메모리의 정보를 가지고 오기

    var debugnewMemory = Provider.of<MemoryProvider>(context, listen: false)
        .searchMemory(newMemoryIdx);

    debugPrint('----providerMemory 의 정보-------');
    debugPrint('${debugnewMemory.toMap()}');

    var newPictureModelList =
        addMemoryHepler.getNewPictureModelList(newMemoryIdx);
    for (var i = 0; i < newPictureModelList.length; i++) {
      await Provider.of<PictureProvider>(context, listen: false)
          .addPicture(newPictureModelList[i]);
      debugPrint('${newPictureModelList[i].toMap()}');
    }

    await Provider.of<SelectedMarkerProvider>(context, listen: false)
        .fetchData();
  }
}
