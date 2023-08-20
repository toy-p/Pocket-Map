import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/screens/editMemory_screen.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:my_tiny_map/view_model/memory_provider.dart';
import 'package:my_tiny_map/view_model/picture_provider.dart';
import 'package:my_tiny_map/view_model/selectedMarker_provider.dart';
import 'package:my_tiny_map/view_model/selelctedMemoryProvider.dart';
import 'package:my_tiny_map/view_model/show_all_memory_helper.dart';
import 'package:provider/provider.dart';

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
        return const CustomBottomSheet();
      });
}

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isLoaded = false;
  var memorys;
  var showAllMemoryHelperList = <ShowAllMemoryHelper>[];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    memorys = Provider.of<MemoryProvider>(context, listen: false).memorys;
    for (var i = 0; i < memorys.length; i++) {
      var markers = Provider.of<MarkerProvider>(context, listen: false)
          .searchMarker(memorys[i].marker_idx!);

      var showAllMemoryHelper = ShowAllMemoryHelper(
        memoryModel: memorys[i],
        markerModel: markers,
      );
      await showAllMemoryHelper.loadPicture(memorys[i].idx!);

      showAllMemoryHelperList.add(showAllMemoryHelper);
      debugPrint('${showAllMemoryHelperList[0].images.length}');
    }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _header(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    itemCount: showAllMemoryHelperList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Memory(
                        markerModel: showAllMemoryHelperList[i].markerModel,
                        memoryModel: memorys[i],
                        title: showAllMemoryHelperList[i].markerModel.title,
                        place: showAllMemoryHelperList[i].place,
                        dateTime: showAllMemoryHelperList[i].datatime,
                        images: showAllMemoryHelperList[i].images,
                        content: showAllMemoryHelperList[i].contents,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }
}

Widget _header() {
  return const Column(
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
        height: 30,
      ),
    ],
  );
}

class Memory extends StatelessWidget {
  const Memory(
      {Key? key,
      required this.markerModel,
      required this.memoryModel,
      required this.title,
      required this.place,
      required this.dateTime,
      required this.images,
      required this.content})
      : super(key: key);
  final MarkerModel markerModel;
  final MemoryModel memoryModel;
  final String title;
  final String place;
  final String dateTime;
  final List<String> images;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            InkWell(
              onTap: () {
                _showDialog(context, memoryModel, markerModel);
              },
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              place,
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
                  children: List<Widget>.generate(
                    images.length,
                    (i) => buildDataRow(images[i]),
                  ),
                ))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              softWrap: true,
              content,
              style: const TextStyle(fontSize: 15),
            )),
      ]),
    );
  }

  Widget buildDataRow(String base64String) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.memory(
          base64Decode(base64String),
          fit: BoxFit.fill,
          width: 100,
          height: 100,
        ));
  }

  // return Image.memory(
  //   base64Decode(base64String),
  //
}

Future _showDialog(context, MemoryModel memoryModel, MarkerModel markerModel) {
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
                EditMemory(context, markerModel, memoryModel);
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
                deleteMemory(context, memoryModel);
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

Future<void> deleteMemory(BuildContext context, MemoryModel memoryModel) async {
  //1. 사진 불러오기
  var picutreList =
      context.read<PictureProvider>().getPictures(memoryModel.idx!);
  //2, 불러온 모든 사진 삭제하기
  for (var i = 0; i < picutreList.length; i++) {
    await context.read<PictureProvider>().deletePicutre(picutreList[i].idx!);
  }
  //3. 메모리 선택하기
  await context.read<MemoryProvider>().deleteMemory(memoryModel.idx!);
  //4. 메모리 삭제하기
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  await bottomSheetBuilder(context);
  //5. 추억 모두 보기 그리고 다시 열기
}

Future<void> EditMemory(BuildContext context, MarkerModel markerModel,
    MemoryModel memoryModel) async {
  //1. selectedMarkerProvider 설정하기
  await context.read<SelectedMarkerProvider>().setInfo(markerModel);
  //2. selectedMemoryProvider 실행하기
  await context.read<SelectedMemoryProvider>().setData(memoryModel);
  //3. EditMemory_screen 이동하기
  await Navigator.push(
      context,
      MaterialPageRoute(
          //selectedMemories
          builder: (context) => const EditMemoryScreen(
              sheetType: BottomSheetType.showAllBottom)));
}
