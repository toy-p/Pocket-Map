import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:my_tiny_map/utils/kakao.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:provider/provider.dart';

class MarkerListScreen extends StatefulWidget {
  const MarkerListScreen({super.key});

  @override
  State<MarkerListScreen> createState() => _MarkerListScreenState();
}

class _MarkerListScreenState extends State<MarkerListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var markers = Provider.of<MarkerProvider>(context, listen: false).markers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers List'),
      ),
      body: ListView.builder(
        itemCount: markers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                var latLng = LatLng(markers[index].lati, markers[index].longi);
                moveToLatLng(latLng);
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 120));
              },
              title: Text(markers[index].title),
              subtitle: Text(markers[index].place!),
              trailing: const Icon(Icons.more_vert),
            ),
          );
        },
      ),
    );
  }
}
