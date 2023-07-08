import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:my_tiny_map/config/route.dart';
import 'package:my_tiny_map/design/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthRepository.initialize(appKey: 'f4f4541d62360e83a055df52209d4e2a');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: nameRoutes,
      theme: AppTheme.mainThemeDate,
    );
  }
}
