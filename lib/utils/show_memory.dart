  import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

import '../config/route.dart';
import '../db_model/image_utility/utility.dart';
import '../db_model/information.dart';
import '../db_model/memory_model.dart';
import '../db_repository/sql_marker_CRUD.dart';
import '../db_repository/sql_memory_CRUD.dart';
import '../db_repository/sql_picture_CRUD.dart';
import '../screens/edit_location_screen.dart';
import '../screens/add_location_screen.dart';
import 'date.dart';

Future showBottom(context){
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
        return StatefulBuilder(
          builder:(context, bottomState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Stack(
                  children: [
                    Column(
                      children: [
                        _header(context),
                        const SizedBox(height: 15),
                        const Divider(thickness: 1, color: Colors.grey),
                        //아아..코드 더러워 지기 시작한다..
                        _body(context),
                      ],
                    ),
                    Positioned(
                        right: 16.0,
                        bottom: 16.0,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            SqlMemoryCRUD().insert(
                              '',
                              getToday(),
                              Provider.of<MarkerSelected>(context,listen:false).marker_idx,
                            );
                            debugPrint("!@");
                            List<Map> aa = await SqlMemoryCRUD().MemoryDataMap(Provider.of<MarkerSelected>(context,listen:false).marker_idx);
                            debugPrint(aa.toString());
                            int len = aa.length;
                            Provider.of<MarkerSelected>(context,listen:false).setMemoryIdx(aa[len-1]['idx']);
                            debugPrint("@#");
                            debugPrint(Provider.of<MarkerSelected>(context,listen:false).memory_idx.toString());
                            Provider.of<MarkerSelected>(context,listen:false).setDateTime(
                                (await SqlMemoryCRUD().MemoryDate(Provider.of<MarkerSelected>(context,listen:false).memory_idx))['datetime']
                            );
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AddLocationScreen())).then((value) {
                              bottomState((){
                                bottomUpdate(context);
                              });
                            });
                            //bottomBodyUpdate(context);
                          },
                          child: Image.asset(
                            'assets/images/map_icon.png',
                          ),
                        )
                    ),
                  ]
              ),
            );
          },
        );
      }
    );
  }
  void bottomUpdate(context) async{
    Provider.of<MarkerSelected>(context,listen:false).setPictureInformation(
        await SqlPictureCRUD().loadPictureAll(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
    );
    Provider.of<MarkerSelected>(context,listen:false).setMemoryInformation(
        await SqlMemoryCRUD().MemoryDataMap(Provider.of<MarkerSelected>(context,listen:false).marker_idx)
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
            Provider.of<MarkerSelected>(context, listen:false).marker_name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.location_searching),
                const SizedBox(width: 10),
                //sqlite
                Text(Provider.of<MarkerSelected>(context, listen:false).place),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _body(context) {
    var itemCount = Provider.of<MarkerSelected>(context, listen:false).memoryInformation.length;
    debugPrint(itemCount.toString());
    debugPrint("또 안돼?");
    //debugPrint(Provider.of<MarkerSelected>(context, listen:false).memoryInformation[0]['idx'].toString());
    List<String> imagelist = [];
    return Expanded(
      child: itemCount > 0
          ? ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                //해당 추억에 포함되어 있는 picture가져오기 + 각각 추억들의 memory_idx에 해당하는 사진을 골라줘서 출력해주기
                List<String> aaa =[];
                List<Map> sss = Provider.of<MarkerSelected>(context, listen:false).pictureInformation;
                //debugPrint("야 이거다 2");
                for(int i=0;i<sss.length;i++)
                {
                  if(sss[i]['memory_idx'] == Provider.of<MarkerSelected>(context, listen:false).memoryInformation[index]['idx'])
                  {
                    aaa.add(sss[i]['picture']);
                  }
                }
                //debugPrint("야 이거다? 이거 뭐냐?");
                aaa.isNotEmpty?
                  imagelist = aaa : imagelist = [];
                //ㅓdebugPrint(imagelist.isEmpty.toString());
                //여기까지 picture전처리 작업.
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
                            Provider.of<MarkerSelected>(context, listen:false).memoryInformation[index]['datetime'],
                            style: const TextStyle(fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              //여기가 추억쪽
                              _showDialogMemory(context,index).then((value) {bottomUpdate(context);});
                            },
                            child: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 갤러리 사진
                      imagelist.isNotEmpty ?
                      SizedBox(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imagelist.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: Utility.imageFromBase64String(imagelist[index]));
                              }
                          ),
                        ) : const SizedBox(),
                      const SizedBox(height: 15),
                      Text(
                        //sqlite
                        Provider.of<MarkerSelected>(context, listen:false).memoryInformation[index]['contents']??'',
                      ),
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
  Future _showDialogMarker(context) {
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
                  //마커 수정은 아직..구현이..
                  Navigator.of(context).pop();
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('수정하기'),
                    //??
                  ],
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  SqlMarkerCRUD().deleteMarker(Provider.of<MarkerSelected>(context,listen:false).lati,Provider.of<MarkerSelected>(context,listen:false).longi);
                  SqlMemoryCRUD().deleteMarkerMemory(Provider.of<MarkerSelected>(context,listen:false).marker_idx);
                  SqlPictureCRUD().deleteMarkerPicture(Provider.of<MarkerSelected>(context,listen:false).marker_idx);
                  Navigator.popUntil(
                      context, ModalRoute.withName(RouteName.home));
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
  Future _showDialogMemory(context,int index) {
    Map infor = Provider.of<MarkerSelected>(context,listen:false).memoryInformation[index];
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
                  Provider.of<MarkerSelected>(context,listen:false).setDateTime(infor['datetime']);
                  Provider.of<MarkerSelected>(context,listen:false).setMemoryIdx(infor['idx']);
                  //Provider.of<MarkerSelected>(context,listen:false)
                  debugPrint(Provider.of<MarkerSelected>(context,listen:false).memory_idx.toString());
                  //여기 손대야함.
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditLocationScreen()));
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
                  SqlMemoryCRUD().deleteMemory(infor['idx']);
                  SqlPictureCRUD().deleteMemoryPicture(infor['idx']);
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
