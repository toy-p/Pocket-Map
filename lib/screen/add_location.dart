import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:my_tiny_map/model/Image.dart';


final List<imgItem> _item = [
  imgItem("assets/images/image1.png","image1"),
  imgItem("assets/images/image2.png","image2"),
  imgItem("assets/images/image1.png","image1"),
  imgItem("assets/images/image2.png","image2"),
];

class Memory_add extends StatefulWidget {

  @override
  State<Memory_add> createState() => _Memory_addState();
}

class _Memory_addState extends State<Memory_add> {

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  File? _image;
  final picker = ImagePicker();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Future getImage(ImageSource imageSource) async{
      final pickedFile = await picker.pickImage(source: imageSource);

      setState(() {
        _image = File(pickedFile!.path);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: (){
            popUp(context);
          },
            child: const Icon(
                Icons.keyboard_backspace_outlined,
                color: Colors.black54
            )
        ),
        centerTitle: true,
        title: const Text('추억 남기기',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white54,
        elevation: 0.0,
        actions: [
          TextButton(onPressed:  (){
            debugPrint(textController.text);
          },
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.white54),
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(40.0)
                        )
                    )
                ),
              ),
              child: Text('저장',style: TextStyle(color: Colors.yellow.shade700,fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.white54,
        icon: Icons.add,
        iconTheme: IconThemeData(color: Colors.black),
        activeIcon : Icons.close,
        elevation: 130,
        spacing: 3,
        direction: SpeedDialDirection.up,
        useRotationAnimation: true,
        //true이면 close버튼을 눌러야만 close할 수 있음.
        closeManually: false,
        animationDuration: Duration(milliseconds: 500),
        spaceBetweenChildren: 9.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera_alt_outlined),
            onTap: (){
              getImage(ImageSource.camera);
            },
            //label: '카메라',
          ),
          SpeedDialChild(
            child: Icon(Icons.photo_library_outlined),
            onTap: (){
              getImage(ImageSource.gallery);
            },
            //label: '갤러리',

          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              child: Container(
                //color: Colors.white54,
                  height : 60,
                //decoration: const BoxDecoration(color: Colors.white54,),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('장소',style: TextStyle(
                              fontSize: 15
                            )),
                            SizedBox(height: 10),
                            Text('방문 일자',style: TextStyle(
                              fontSize: 15
                            )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('인하대학교 경영대학',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                            const SizedBox(height: 10),
                            Text(getToday(),
                                style:const TextStyle(
                              fontSize : 18,
                                  fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ),
            ),
            //노트 입력
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFF59D),
                      //0xFFFF176
                      borderRadius: BorderRadius.all(
                          Radius.circular(15)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,20.0),
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.text,
                      showCursor: true,
                      maxLines: null,
                      autofocus: true,
                      //focusNode: _focusNode,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: '추억을 남겨보세요.',
                      ),
                    ),
                  )
                ),
              )
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 1, 20,0),
              child: Divider(thickness: 1,color: Colors.grey),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,20.0),
                child: showImage(),
            )
          ],
        ),
      ),
    );
  }

  Widget showImage() {
    final widthCount = MediaQuery.of(context).size.width / 153.3;
    if (_image != null)
      return Container(
          alignment: AlignmentDirectional(0.0, 0.0),
          height: 200,
          child: const Text('사진을 추가해 보세요',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
      );
    else
      return Container(
        height: 200,
        child: GridView.count(
          crossAxisCount: widthCount.toInt(),
          scrollDirection: Axis.vertical,
          children: List.generate(_item.length,(index){
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(_item[index].image,width:128,height:128),
                ),
                GestureDetector(
                  onTap: () => deletePopUp(context),
                    child: Icon(Icons.delete_outline_outlined)
                )
              ],
            );
          }),
        ),
      );
  }
  void popUp(context){
    showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: const Text('정말 나가시겠어요?',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w800),),
            content: Container(
              height: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('작성중인 내용을 임시 저장하거나'),
                  const Text('계속 수정할 수 있습니다.'),
                  const SizedBox(height:20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          child: Text(
                            '나가기',
                            style: TextStyle(
                                color: Colors.deepOrange.shade300,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        onTap: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                        },
                      ),
                      InkWell(
                          child: Text(
                            '계속 수정',
                            style: TextStyle(
                                color: Colors.deepOrange.shade300,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        onTap: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                        },
                      ),
                     // TextButton(onPressed: (){}, child: Text('나가기',style: TextStyle(color: Colors.deepOrange.shade400,fontSize: 15.0,fontWeight: FontWeight.bold))),
                     // TextButton(onPressed: (){}, child: Text('계속 수정',style: TextStyle(decorationColor: Colors.black,color: Colors.deepOrange.shade400,fontSize: 15.0,fontWeight: FontWeight.bold))),
                    ],
                  )
                ],
              ),
            ),
          );
        },
    );
  }
  void deletePopUp(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: const Text('이미지 삭제',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w800),),
            content: Container(
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('삭제 하시겠습니까?'),
                  const SizedBox(height:20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Text(
                          '취소',
                          style: TextStyle(
                              color: Colors.deepOrange.shade300,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text(
                          '삭제',
                          style: TextStyle(
                              color: Colors.deepOrange.shade300,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                     ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String strToday = formatter.format(now);
  return strToday;
}
}