import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class Image_Provider extends ChangeNotifier {
  AssetEntityImage? addingImageList;

  void addImage(AssetEntity assetEntity) {
    // addImage = AssetEntityImage(
    //   assetEntity,
    //   isOriginal: false,
    //   fit: BoxFit.cover,
    // );

    notifyListeners(); // 숫자가 증가했다는 것을 ChangeNotifierProvider에 알려주기 위해 notifyListeners()를 호출한다.
  }
}
