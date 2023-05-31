import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:my_tiny_map/screen/change_location.dart';
import 'package:my_tiny_map/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: '', // 자신의 Client id
    onAuthFailed: (ex) {
      print("********* 네이버맵 인증오류 : $ex *********");
      // 401 - 잘못된 클라이언트 ID 지정, 잘못된 클라이언트 유형을 사용, 콘솔에 등록된 앱 패키지 이름과 미일치
      // 429 - 콘솔에서 Maps 서비스를 선택하지 않음, 사용 한도 초과
      // 800 - 라이언트 ID 미지정
    },
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), //ChangeLocation(),
    ),
  );
}
