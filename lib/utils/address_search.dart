import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kpostal/kpostal.dart';
import 'package:my_tiny_map/datas/models/kakaomap_model.dart';
import 'package:my_tiny_map/utils/kakao.dart';
import 'package:provider/provider.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';

class AddressSearch extends StatefulWidget {
  const AddressSearch({super.key});

  @override
  State<AddressSearch> createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  GetLocation getL = GetLocation();
  late Marker marker;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: GestureDetector(
        onTap: () async {
          //아무 결과도 없이 뒤로 가기 처리 위함.
          getL.roadAddress='-';
          await onTap();
          print(getL.roadAddress);
          if(getL.roadAddress!='-')
            await moveLocation();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.3),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 12),
                      //가리키고있는 마커와 상관없이, 검색결과에서 찾고자 하는 위치를 callback 하였을 때
                      if(getL.roadAddress != '-' )
                          Text( getL.roadAddress,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey.shade800,
                            ),
                          )
                      else
                          Provider.of<MarkerProvider>(context).currentMarker != null ?
                          Text(
                            Provider.of<MarkerProvider>(context).currentMarker!.place.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey.shade800,
                            ),
                          ) :
                          //현재 가리키고 있는 마커가 존재한데, 검색하다가 뒤로 가기 눌렀을 때
                          Text(
                            '검색할 내용을 입력해주세요.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  '검색된 위치 : ${getL.roadAddress} 검색된 위도 : ${getL.init_latitude} & 경도 : ${getL.init_longitude}');
            });
          },
        ),
      ),
    );
  }

  Future moveLocation() async {
    // 딜레이가 없으면 검색된 위도,경도의 값이 반영되지 않아 검색 후 딜레이를 주어서 반영되게 함
    await Future.delayed(const Duration(milliseconds: 4000), () {
      mapController.setCenter(LatLng(getL.init_latitude, getL.init_longitude));

      // 검색 후 마커 찍음
      // 검색 후에 위치를 db에 추가하는게 아닌, 지도상에서만 marker를 추가하기에, 해당 마커를 눌렀을때의 작동이 정의되어있지 않음.
      /*
      marker = Marker(
        markerId: markers.length.toString(),
        latLng: LatLng(getL.init_latitude, getL.init_longitude),
        width: 30,
        height: 44,
        offsetX: 15,
        offsetY: 44,
        // markerImageSrc: 'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
      );*/ /*
      double _a = double.parse(getL.init_latitude.toStringAsFixed(6));
      double _b = double.parse(getL.init_longitude.toStringAsFixed(6));
      SqlMarkerCRUD().insert(getL.roadAddress,_a,_b);*/
      /*
      markers.add(marker);
      mapController.addMarker(markers: markers.toList());
      */
    });
  }
}
