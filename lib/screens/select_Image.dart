import 'package:flutter/material.dart';
import 'package:my_tiny_map/datas/models/Album.dart';
import 'package:my_tiny_map/utils/grid_photo.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({Key? key}) : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  List<AssetPathEntity>? _paths;
  List<Album> _albums = [];
  late List<AssetEntity> _images;
  int _currentPage = 0;
  late Album _currentAlbum;
  AssetEntityImage? selectedImage;

  Future<void> checkPermission() async {
    var ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      await getAlbum();
    } else {
      await PhotoManager.openSetting();
    }
  }

  Future<void> getAlbum() async {
    _paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    _albums = _paths!.map((e) {
      return Album(
        id: e.id,
        name: e.isAll ? '모든 사진' : e.name,
      );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  Future<void> getPhotos(
    Album album, {
    bool albumChange = false,
  }) async {
    _currentAlbum = album;
    albumChange ? _currentPage = 0 : _currentPage++;

    var loadImages = await _paths!
        .singleWhere((element) => element.id == album.id)
        .getAssetListPaged(
          page: _currentPage,
          size: 20,
        );

    setState(() {
      if (albumChange) {
        _images = loadImages;
      } else {
        _images.addAll(loadImages);
      }
    });
  }

  void changeImage(AssetEntity assetEntity) {
    setState(() {
      selectedImage = AssetEntityImage(
        assetEntity,
        isOriginal: false,
        fit: BoxFit.cover,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: _albums.isNotEmpty
                ? DropdownButton(
                    value: _currentAlbum,
                    items: _albums
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ))
                        .toList(),
                    onChanged: (value) => getPhotos(value!, albumChange: true),
                  )
                : const SizedBox()),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          var scrollPixels =
              scroll.metrics.pixels / scroll.metrics.maxScrollExtent;

          print('scrollPixels = $scrollPixels');
          if (scrollPixels > 0.7) getPhotos(_currentAlbum);

          return false;
        },
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              selectedImage != null
                  ? SizedBox(height: 400, child: selectedImage)
                  : Container(
                      height: 400,
                      color: Colors.black45,
                    ),
              Expanded(
                child: Container(
                  child: _paths == null
                      ? const Center(child: CircularProgressIndicator())
                      : GridPhoto(images: _images, changeImage: changeImage),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
