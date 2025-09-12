import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera/camera.dart';
import 'camera_page.dart';
import 'write_page.dart';

class GalleryGridPage extends StatefulWidget {
  const GalleryGridPage({super.key});

  @override
  State<GalleryGridPage> createState() => _GalleryGridPageState();
}

class _GalleryGridPageState extends State<GalleryGridPage> {
  List<AssetEntity> _mediaList = [];
  List<String> _appSavedImages = [];

  // 선택한 갤러리 사진 (id → asset)
  Map<String, AssetEntity> _selectedGalleryImages = {};

  // 선택한 앱 내 사진 (경로 Set)
  Set<String> _selectedAppImages = {};

  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoad();
  }

  Future<void> _checkPermissionAndLoad() async {
    if (_permissionChecked) return;

    final ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth || ps.hasAccess) {
      _permissionChecked = true;
      _loadGallery();
    } else {
      await PhotoManager.openSetting();
    }
  }

  Future<void> _loadGallery() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    final media = await albums.first.getAssetListPaged(page: 0, size: 200);
    setState(() {
      _mediaList = media;
    });
  }

  void _toggleGallerySelection(AssetEntity asset) {
    setState(() {
      if (_selectedGalleryImages.containsKey(asset.id)) {
        _selectedGalleryImages.remove(asset.id);
      } else {
        _selectedGalleryImages[asset.id] = asset;
      }
    });
  }

  void _toggleAppSelection(String path) {
    setState(() {
      if (_selectedAppImages.contains(path)) {
        _selectedAppImages.remove(path);
      } else {
        _selectedAppImages.add(path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // ← 아이콘(뒤로가기 등) 색상만 흰색
        ),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: _mediaList.length + _appSavedImages.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            // 📸 카메라 버튼
            return GestureDetector(
              onTap: () async {
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
          bool isSelected;

          if (index <= _appSavedImages.length) {
            // 앱 내 사진
            path = _appSavedImages[index - 1];
            imageWidget = Image.file(File(path), fit: BoxFit.cover);
            isSelected = _selectedAppImages.contains(path);
          } else {
            // 갤러리 사진
            final asset = _mediaList[index - _appSavedImages.length - 1];
            path = asset.id;
            imageWidget = FutureBuilder<Uint8List?>(
              future: asset.thumbnailDataWithSize(
                const ThumbnailSize(200, 200),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return Container(color: Colors.black12);
              },
            );
            isSelected = _selectedGalleryImages.containsKey(path);
          }

          return GestureDetector(
            onTap: () {
              if (index <= _appSavedImages.length) {
                _toggleAppSelection(path);
              } else {
                final asset = _mediaList[index - _appSavedImages.length - 1];
                _toggleGallerySelection(asset);
              }
            },
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
      bottomNavigationBar:
          (_selectedAppImages.isNotEmpty || _selectedGalleryImages.isNotEmpty)
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () async {
                  // ✅ 선택된 사진들 모으기
                  final selectedAppFiles = _selectedAppImages
                      .map((p) => File(p))
                      .toList();

                  final selectedGalleryFiles = <File>[];
                  for (final asset in _selectedGalleryImages.values) {
                    final file = await asset.file;
                    if (file != null) selectedGalleryFiles.add(file);
                  }

                  final allSelected = [
                    ...selectedAppFiles,
                    ...selectedGalleryFiles,
                  ];

                  // 글쓰기 페이지로 이동
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WritePage(selectedImages: allSelected),
                      ),
                    );
                  }
                },
                child: const Text("등록하기"),
              ),
            )
          : null,
    );
  }
}
