import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tiny_map/config/route.dart';
import 'package:my_tiny_map/datas/models/image_model.dart';
import 'package:my_tiny_map/db_model/information.dart';
import 'package:my_tiny_map/db_repository/sql_memory_CRUD.dart';
import 'package:my_tiny_map/utils/date.dart';
import 'package:my_tiny_map/db_model/picture.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';
import 'package:my_tiny_map/db_repository/sql_picture_CRUD.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';

import '../db_model/image_utility/utility.dart';
import '../db_model/memory_model.dart';
import '../db_repository/sql_marker_CRUD.dart';
import '../utils/show_memory.dart';

class EditLocationScreen extends StatefulWidget {
  const EditLocationScreen({super.key});

  @override
  State<EditLocationScreen> createState() => _EditLocationScreen();

}

class _EditLocationScreen extends State<EditLocationScreen> {
  final ImagePicker _picker = ImagePicker();
  List<Map> firstPictureList = [];
  String? firstContents;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  TextEditingController textController = TextEditingController();
  List<Map> pictureList = [];
  Map memorydatecontent = {};

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _asyncMethod();
  }
  void _asyncMethod() async{
    pictureList = await SqlPictureCRUD().loadPicture(
        Provider.of<MarkerSelected>(context,listen:false).memory_idx);
    debugPrint("이거 설마 state안됨?");
    debugPrint(pictureList.toString());
    debugPrint("되는거 같은디");
    firstPictureList = pictureList;
    debugPrint(pictureList.toString());
    memorydatecontent = await SqlMemoryCRUD().MemoryDate(Provider.of<MarkerSelected>(context,listen:false).memory_idx);
    //여기서 받아와야하는게 마커 장소와 방문 일자, 적었던 추억내용.
    //=MarkerSelected().place, memorydatecontent[0], memorydatecontent[1]
    textController.text = memorydatecontent['contents']??'';
    Provider.of<MarkerSelected>(context,listen:false).setDateTime(memorydatecontent['datetime']);
    firstContents = textController.text;
    setState(() {
    });
  }

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
                      onTap: () async {
                        //나가기 하면 원래 했던 작업 다 지우고
                        SqlPictureCRUD().deleteMemoryPicture(Provider.of<MarkerSelected>(context,listen:false).memory_idx);
                        //초기에 저장해놧던 값 다 집어넣어주기.
                        for(int i=0;i<firstPictureList.length;i++)
                          {
                            Picture picture1 = new Picture(
                              marker_idx: Provider.of<MarkerSelected>(context,listen:false).marker_idx, //마커 index
                              memory_idx: Provider.of<MarkerSelected>(context,listen:false).memory_idx, //메모리 index 이것도 index화 해야할거 같은데.. memory_idx를 불러올수 있는 곳이...없어...
                              picture: firstPictureList[i]['picture'],
                            );
                            SqlPictureCRUD().insert(picture1);
                          }
                        Navigator.popUntil(
                            context,ModalRoute.withName(RouteName.home)
                        );
                        Provider.of<MarkerSelected>(context,listen:false).setPictureInformation(
                            await SqlPictureCRUD().loadPictureAll(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
                        );
                        Provider.of<MarkerSelected>(context,listen:false).setMemoryInformation(
                        await SqlMemoryCRUD().MemoryDataMap(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
                        );
                        showBottom(context);
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
  void savePopUp(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            '저장하시겠습니까?',
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
                        '계속 수정',
                        style: TextStyle(
                            color: Colors.deepOrange.shade300,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      child: Text(
                        '저장',
                        style: TextStyle(
                            color: Colors.deepOrange.shade300,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        SqlMemoryCRUD().update(
                          textController.text,
                          Provider.of<MarkerSelected>(context,listen:false).memory_idx,
                        );
                        //showbottomsheet로 이동
                        Navigator.popUntil(
                          context,ModalRoute.withName(RouteName.home)
                        );
                        Provider.of<MarkerSelected>(context,listen:false).setPictureInformation(
                            await SqlPictureCRUD().loadPictureAll(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
                        );
                        Provider.of<MarkerSelected>(context,listen:false).setMemoryInformation(
                            await SqlMemoryCRUD().MemoryDataMap(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
                        );
                        showBottom(context);
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

  //카메라 촬영 결과 저장
  void getImage(ImageSource source) async {
    String firstButtonText;
    await _picker.pickImage(source: source).then((XFile? recorededImage){
      if(recorededImage!=null && recorededImage.path!=null) {
        setState(() {
          firstButtonText='saving in progress..';
        });
        GallerySaver.saveImage(recorededImage.path).then((bool? success) async {
          String imgString = Utility.base64String(await recorededImage.readAsBytes());
          Picture Picture1 = Picture(
          marker_idx: Provider.of<MarkerSelected>(context,listen:false).marker_idx, //마커 index
          memory_idx: Provider.of<MarkerSelected>(context,listen:false).memory_idx, //메모리 index 이것도 index화 해야할거 같은데.. memory_idx를 불러올수 있는 곳이...없어...
          picture: imgString,
          );
          await SqlPictureCRUD().insert(Picture1);
          pictureList = await SqlPictureCRUD().loadPicture(Provider.of<MarkerSelected>(context,listen:false).memory_idx);
          setState((){
          });
        });
      }
    });
  }

  //사진 선택
  void getMultiImage() async {
    var images = await _picker.pickMultiImage();

    //image를 string으로 변환 & sql에 저장까지.
    for(int i=0;i<images.length;i++) {
      String imgString = Utility.base64String(await images[i].readAsBytes());
      Picture picture1 = new Picture(
        marker_idx: Provider.of<MarkerSelected>(context,listen:false).marker_idx, //마커 index
        memory_idx: Provider.of<MarkerSelected>(context,listen:false).memory_idx, //메모리 index 이것도 index화 해야할거 같은데.. memory_idx를 불러올수 있는 곳이...없어...
        picture: imgString,
      );
      await SqlPictureCRUD().insert(picture1);
    }
    pictureList = await SqlPictureCRUD().loadPicture(Provider.of<MarkerSelected>(context,listen:false).memory_idx);
    setState((){
    });
    /*
    setState(() {
      _pickedImages.addAll(images);
    });*/
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: (){
                //여기에서야 memory를 저장하면, memory_idx를 알수가 없음.
                savePopUp(context);
                debugPrint(textController.text);
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
                              Text(Provider.of<MarkerSelected>(context,listen:false).place,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 10),
                              Text(Provider.of<MarkerSelected>(context,listen:false).dateTime,
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
            Expanded(child: pictureList.isEmpty ? showImage() : showImage2()),
          ],
        ),
      ),
    );
  }

  Widget showImage() {
    debugPrint("사진 있잖아?");
    debugPrint(pictureList.toString());
    debugPrint("사진이 없어용");
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
  }

  Widget showImage2(){
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10, //수평 Padding
            crossAxisSpacing: 10,
          ),
          //음 이걸 어떻게 처리해야하지
          itemCount: pictureList.length,
          itemBuilder: (context, index) {
            //picture.idx가 primary key이므로.. picture.idx를 통해 delete를 해준다.
            return _gridPhotoItem(index);
          },
        )
    );
  }
  Widget _gridPhotoItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Utility.imageFromBase64String(pictureList[index]['picture']),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () async {
                SqlPictureCRUD().deletePicture(pictureList[index]['idx']);
                pictureList = await SqlPictureCRUD().loadPicture(Provider.of<MarkerSelected>(context,listen:false).memory_idx);
                setState(() {
                  //_pickedImages.remove(e);
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
}
