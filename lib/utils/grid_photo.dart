import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GridPhoto extends StatefulWidget {
  GridPhoto({
    required this.images,
    required this.changeImage,
    Key? key,
  }) : super(key: key);
  List<AssetEntity> images;
  final Function changeImage;

  @override
  State<GridPhoto> createState() => _GridPhotoState();
}

class _GridPhotoState extends State<GridPhoto> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const BouncingScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: widget.images.map((e) {
        return GestureDetector(
          onTap: () =>
              widget.changeImage(e), // select Image 를 바꿔주면 됨 provider 로
          child: AssetEntityImage(
            e,
            isOriginal: false,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
