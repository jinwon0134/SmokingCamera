import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera/camera.dart';
import 'camera_page.dart';

class GalleryGridPage extends StatefulWidget {
  const GalleryGridPage({super.key});

  @override
  State<GalleryGridPage> createState() => _GalleryGridPageState();
}

class _GalleryGridPageState extends State<GalleryGridPage> {
  List<AssetEntity> _mediaList = [];
  List<String> _appSavedImages = [];
  Set<String> _selectedImages = {};
  bool _onlyRecent = true; // 최근항목만 보기 토글

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

    List<AssetEntity> media;
    if (_onlyRecent) {
      media = await albums.first.getAssetListPaged(page: 0, size: 100);
    } else {
      media = await albums.first.getAssetListPaged(page: 0, size: 10000);
    }

    setState(() {
      _mediaList = media;
    });
  }

  void _toggleSelection(String path) {
    setState(() {
      if (_selectedImages.contains(path)) {
        _selectedImages.remove(path);
      } else {
        _selectedImages.add(path);
      }
    });
  }

  void _toggleRecent() {
    setState(() {
      _onlyRecent = !_onlyRecent;
    });
    _loadGallery();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = (screenWidth - 4) / 3; // 3열, spacing 2*2

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("갤러리 선택", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 상단 최근항목 토글 버튼
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleRecent,
                  child: Row(
                    children: [
                      Text(
                        "최근 항목",
                        style: TextStyle(
                          fontSize: 16,
                          color: _onlyRecent ? Colors.blue : Colors.black,
                        ),
                      ),
                      Icon(
                        _onlyRecent
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: _onlyRecent ? Colors.blue : Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: _mediaList.length + _appSavedImages.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 카메라 버튼
                  return GestureDetector(
                    onTap: () async {
                      try {
                        final cameras = await availableCameras();
                        if (cameras.isNotEmpty) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CameraPage(camera: cameras.first),
                            ),
                          );
                          if (result != null && result is String) {
                            setState(() {
                              _appSavedImages.add(result);
                            });
                          }
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

                Widget imageWidget;
                String path;

                if (index <= _appSavedImages.length) {
                  path = _appSavedImages[index - 1];
                  imageWidget = Image.file(File(path), fit: BoxFit.cover);
                } else {
                  final asset = _mediaList[index - _appSavedImages.length - 1];
                  path = asset.id;
                  imageWidget = FutureBuilder<Uint8List?>(
                    future: asset.thumbnailDataWithSize(
                      ThumbnailSize(asset.width, asset.height),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      }
                      return Container(color: Colors.black12);
                    },
                  );
                }

                final isSelected = _selectedImages.contains(path);

                return GestureDetector(
                  onTap: () => _toggleSelection(path),
                  child: Stack(
                    children: [
                      Positioned.fill(child: imageWidget),
                      if (isSelected)
                        const Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedImages.isNotEmpty
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () {
                  print("등록된 사진: $_selectedImages");
                },
                child: const Text("등록하기"),
              ),
            )
          : null,
    );
  }
}
