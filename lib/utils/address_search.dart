import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:kpostal/kpostal.dart';
import 'package:my_tiny_map/datas/models/kakaomap_model.dart';
import 'package:my_tiny_map/utils/kakao.dart';

class AddressSearch extends StatefulWidget {
  const AddressSearch({super.key});

  @override
  State<AddressSearch> createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  GetLocation getL = GetLocation();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: GestureDetector(
        onTap: () {
          onTap();
          moveLocation();
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
                      getL.roadAddress != '-'
                          ? Text(
                              getL.roadAddress,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey.shade800,
                              ),
                            )
                          : Text(
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
          callback: (Kpostal result) {
            setState(() {
              getL.roadAddress = result.address;
              getL.latitude = result.latitude.toString();
              getL.longitude = result.longitude.toString();
              getL.init_latitude = double.parse(getL.latitude);
              getL.init_longitude = double.parse(getL.longitude);
            });
          },
        ),
      ),
    );
  }

  Future moveLocation() async {
    // 딜레이가 없으면 검색된 위도,경도의 값이 반영되지 않아 검색 후 딜레이를 주어서 반영되게 함
    await Future.delayed(const Duration(milliseconds: 12000), () {
      print('검색된 위도 : ${getL.init_latitude} & 경도 : ${getL.init_longitude}');
      mapController.setCenter(LatLng(getL.init_latitude, getL.init_longitude));
    });
  }
}
