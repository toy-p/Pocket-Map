import 'package:flutter/material.dart';
import 'package:my_tiny_map/utils/add_marker.dart';
import 'package:my_tiny_map/utils/address_search.dart';
import 'package:my_tiny_map/utils/kakao.dart';
import 'package:my_tiny_map/utils/show_all_memory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
      ),
      body: Stack(
        children: [
          map(context),
          const AddressSearch(),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          floatingButtonCustom(
            const Icon(Icons.gps_fixed_rounded),
            0.0,
            context,
            'getLocation',
          ),
          floatingButtonCustom(
            const Icon(Icons.add_location_alt_outlined),
            0.2,
            context,
            'addLocation',
          ),
          floatingButtonCustom(
            const Icon(Icons.reorder),
            0.4,
            context,
            'showMemory',
          ),
        ],
      ),
    );
  }

  Widget floatingButtonCustom(Icon icon, double val, context, String heroTag) {
    return Align(
      alignment:
          Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - val),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          if (val == 0.0) {
            getLocation();
          } else if (val == 0.2) {
            dialogBuilder(context);
            // showBottom(context); // 해당 위치 마커 추억 보기
          } else if (val == 0.4) {
            bottomSheetBuilder(context);
            // showBottom(context); // 해당 위치 마커 추억 보기
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: icon,
      ),
    );
  }
}
