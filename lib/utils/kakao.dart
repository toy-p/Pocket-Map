import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'package:my_tiny_map/utils/show_memory.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:provider/provider.dart';

late KakaoMapController mapController;

class BuildkakaoMap extends StatefulWidget {
  const BuildkakaoMap({super.key});

  @override
  State<BuildkakaoMap> createState() => _BuildkakaoMapState();
}

class _BuildkakaoMapState extends State<BuildkakaoMap> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    loadData(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(context);
    });
  }

  Future<void> loadData(BuildContext context) async {
    var markerProvider = context.read<MarkerProvider>();

    // 필요한 경우 비동기 작업 (예: API 호출 등)을 여기서 수행하세요.
    await Future.delayed(const Duration(milliseconds: 10));

    var markerModels = markerProvider.markers;

    setState(() {
      _markers.clear();
      for (var markerModel in markerModels) {
        _markers.add(Marker(
            markerId: markerModel.id.toString(),
            latLng: LatLng(markerModel.lati, markerModel.longi),
            width: 24,
            height: 36));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var markerProvider = context.watch<MarkerProvider>();
    var markerModels = markerProvider.markers;

    _markers.clear();
    for (var markerModel in markerModels) {
      debugPrint('${markerModel.id} 생성완료');
      _markers.add(Marker(
          markerId: markerModel.id.toString(),
          latLng: LatLng(markerModel.lati, markerModel.longi),
          width: 24,
          height: 36));
    }

    Future.delayed(const Duration(milliseconds: 200));
    return KakaoMap(
      onMapCreated: (controller) async {
        await onMapCreated(controller);
      },
      onMarkerTap: (markerId, latLng, zoomLevel) async {
        await Future.delayed(const Duration(milliseconds: 100));
        await showBottom(int.parse(markerId), context);
      },
      markers: _markers.toList(),
    );
  }

  Future<void> onMapCreated(KakaoMapController controller) async {
    mapController = controller;
  }
}

Future<void> moveToLatLng(LatLng latLng, {int delayMs = 1200}) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  mapController.setCenter(latLng);
}
