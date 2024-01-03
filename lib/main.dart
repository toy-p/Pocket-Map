import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:my_tiny_map/config/route.dart';
import 'package:my_tiny_map/db_repository/sql_database.dart';
import 'package:my_tiny_map/design/theme.dart';
import 'package:my_tiny_map/view_model/marker_provider.dart';
import 'package:my_tiny_map/view_model/memory_provider.dart';
import 'package:my_tiny_map/view_model/picture_provider.dart';
import 'package:my_tiny_map/view_model/selectedMarker_provider.dart';
import 'package:my_tiny_map/view_model/selelctedMemoryProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDataBase.instance;
  AuthRepository.initialize(appKey: 'f4f4541d62360e83a055df52209d4e2a');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MarkerProvider()),
    ChangeNotifierProvider(create: (_) => PictureProvider()),
    ChangeNotifierProvider(create: (_) => MemoryProvider()),
    ChangeNotifierProvider(create: (_) => SelectedMarkerProvider()),
    ChangeNotifierProvider(create: (_) => SelectedMemoryProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //DB 저장 되어있는 정보들을 앱 시작전에 불러오기
    context.read<MarkerProvider>().fetchMarkers();
    context.read<MemoryProvider>().fetchMemory();
    context.read<PictureProvider>().fetchPicutre();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: nameRoutes,
      theme: AppTheme.mainThemeDate,
    );
  }
}
