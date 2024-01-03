import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/marker_model.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_model/picture_model.dart';
import 'package:my_tiny_map/screens/addmemory_screen.dart';
import 'package:my_tiny_map/screens/editMemory_screen.dart';
import 'package:my_tiny_map/utils/edit_marker.dart';
import 'package:my_tiny_map/utils/image_utility/utility.dart';
import 'package:my_tiny_map/utils/showAlertDialog.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:my_tiny_map/view_model/memory_provider.dart';
import 'package:my_tiny_map/view_model/picture_provider.dart';
import 'package:my_tiny_map/view_model/selectedMarker_provider.dart';
import 'package:my_tiny_map/view_model/selelctedMemoryProvider.dart';
import 'package:provider/provider.dart';

Future showBottom(int markerId, context) {
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
      return BottomSheetWidget(markerId: markerId);
    },
  );
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key, required this.markerId});
  final int markerId;

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
  }

  Future<void> _loadData(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1));

    var selectedMarkerProvider =
        Provider.of<SelectedMarkerProvider>(context, listen: false);
    await selectedMarkerProvider.setInfo(
        Provider.of<MarkerProvider>(context, listen: false)
            .searchMarker(widget.markerId));
  }

  @override
  Widget build(BuildContext context) {
    var selectedMarkerProvider = Provider.of<SelectedMarkerProvider>(context);

    if (selectedMarkerProvider.isLoading ||
        selectedMarkerProvider.marker == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Stack(children: [
          Column(
            children: [
              _header(context, selectedMarkerProvider.marker!),
              const SizedBox(height: 15),
              const Divider(thickness: 1, color: Colors.grey),
              _body(context, selectedMarkerProvider.memories),
            ],
          ),
          Positioned(
              right: 16.0,
              bottom: 16.0,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMemoryScreen()));
                },
                child: Image.asset(
                  'assets/images/map_icon.png',
                ),
              )),
        ]),
      );
    }
  }
}

Widget _header(context, MarkerModel marker) {
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
                //여기가 마커
                _showDialogMarker(context);
              },
              child: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          //sqlite
          marker.title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              const Icon(Icons.location_searching),
              const SizedBox(width: 10),
              //sqlite
              Text(marker.place!),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _body(context, List<MemoryModel> selectedMarkerMemorys) {
  debugPrint('${selectedMarkerMemorys.length}');
  var itemCount = selectedMarkerMemorys.length;

  return Expanded(
    child: itemCount > 0
        ? ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              var currentIdxMemory =
                  selectedMarkerMemorys[index]; //현제 타일(index)의 메모리 Model 입니다.
              var pictureList = Provider.of<SelectedMarkerProvider>(context)
                  .searchPictures(currentIdxMemory
                      .idx!); //현제 추억에 해당하는 Picutre 을 담고 있는 PictureList 입니다.

              //해당 추억에 포함되어 있는 picture가져오기 + 각각 추억들의 memory_idx에 해당하는 사진을 골라줘서 출력해주기
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
                        Text(
                          //sqlite
                          currentIdxMemory.datetime,
                          style: const TextStyle(fontSize: 15),
                        ),
                        InkWell(
                          onTap: () {
                            //여기가 추억쪽
                            _showDialogMemory(context, index);
                          },
                          child: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// 갤러리 사진

                    showImage(context, pictureList),
                    const SizedBox(height: 15),
                    Text(currentIdxMemory.contents),
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

Widget showImage(context, List<PictureModel> pictureList) {
  return pictureList.isNotEmpty
      ? SizedBox(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pictureList.length,
              itemBuilder: (context, index) {
                return Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Utility.imageFromBase64String(
                        pictureList[index].picture!));
              }),
        )
      : const SizedBox();
}

Future _showDialogMarker(context) {
  var selectedMarkerProvider =
      Provider.of<SelectedMarkerProvider>(context, listen: false);

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
                EditMarker(context);
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
                //마커를 정말 삭제하시겠습니까?

                if (selectedMarkerProvider.memories.isNotEmpty) {
                  //마커의 추억들이 모두 삭제가 되지 않았습니다. 모든 추억들을 삭제해주시고 마커를 삭제해주세요
                  showAlertDialog(context, '삭제 실패',
                      '마커의 추억들이 모두 삭제가 되지 않았습니다. 모든 추억들을 삭제해주시고 마커를 삭제해주세요');
                } else {
                  //마커가 삭제되었습니다.
                  var deletedMarkerId = selectedMarkerProvider.marker!.id;
                  //Provider.of<MarkerProvider>(context)
                  //  .deleteMarker(deletedMarkerId!);
                  context.read<MarkerProvider>().deleteMarker(deletedMarkerId!);
                  selectedMarkerProvider.initSelectedMarker();
                  context.read<MarkerProvider>().initCurrentMarker();

                  Navigator.pop(context);
                  Navigator.pop(context);

                  showAlertDialog(context, '삭제 성공', '마커가 삭제되었습니다.');
                }
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

Future _showDialogMemory(context, int index) {
  var memory = Provider.of<SelectedMarkerProvider>(context, listen: false)
      .memories[index];

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
                context.read<SelectedMemoryProvider>().setData(memory);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //selectedMemories
                        builder: (context) => const EditMemoryScreen(
                            sheetType: BottomSheetType.showBottom)));
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
              onTap: () async {
                debugPrint('삭제됩니다');
                await deleteMemory(context, memory);

                //사진도 지우기
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

Future<void> deleteMemory(context, MemoryModel memory) async {
  //var pictureList =
  // context.read<SelectedMarkerProvider>().searchPictures(memory.idx!);
  var selectedMarkerProvider =
      Provider.of<SelectedMarkerProvider>(context, listen: false);
  var pictureList = selectedMarkerProvider.searchPictures(memory.idx!);
  await Future.delayed(const Duration(milliseconds: 100));
  for (var i = 0; i < pictureList.length; i++) {
    await Provider.of<PictureProvider>(context, listen: false)
        .deletePicutre(pictureList[i].idx!);
    await Future.delayed(const Duration(milliseconds: 10));
  }
  await Provider.of<MemoryProvider>(context, listen: false)
      .deleteMemory(memory.idx!);
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  await Future.delayed(const Duration(milliseconds: 10));

  await showBottom(selectedMarkerProvider.marker!.id!, context);
}
