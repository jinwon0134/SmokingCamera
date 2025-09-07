import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'camera_page.dart';
import 'package:camera/camera.dart';

class GalleryGridPage extends StatefulWidget {
  const GalleryGridPage({super.key});

  @override
  State<GalleryGridPage> createState() => _GalleryGridPageState();
}

class _GalleryGridPageState extends State<GalleryGridPage> {
  List<AssetEntity> _mediaList = [];

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      PhotoManager.openSetting();
      return;
    }

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    List<AssetEntity> media = await albums.first.getAssetListPaged(
      page: 0,
      size: 100,
    );

    setState(() {
      _mediaList = media;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("갤러리 선택")),
      body: GridView.builder(
        itemCount: _mediaList.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            // 카메라 버튼
            return GestureDetector(
              onTap: () async {
                try {
                  final cameras = await availableCameras();
                  if (cameras.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraPage(camera: cameras.first),
                      ),
                    );
                  }
                } catch (e) {
                  print('카메라 에러: $e');
                }
              },
              child: Container(
                color: Colors.black12,
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.black54,
                ),
              ),
            );
          }

          final asset = _mediaList[index - 1];

          return FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
