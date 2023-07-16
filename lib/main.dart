import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:my_tiny_map/config/route.dart';
import 'package:my_tiny_map/design/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: 'fw9q4cz6x4',
    onAuthFailed: (error) {
      print('Auth failed : $error');
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: nameRoutes,
      theme: AppTheme.mainThemeDate,
    );
  }
}