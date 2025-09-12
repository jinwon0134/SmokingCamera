import 'dart:io'; // File 사용
import 'dart:typed_data'; // Uint8List 사용

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'; // 갤러리/사진 접근
import 'package:camera/camera.dart'; // 카메라 사용
import 'camera_page.dart'; // 카메라 촬영 화면

// 갤러리 선택 페이지
class GalleryGridPage extends StatefulWidget {
  const GalleryGridPage({super.key});

  @override
  State<GalleryGridPage> createState() => _GalleryGridPageState();
}

class _GalleryGridPageState extends State<GalleryGridPage> {
  // 갤러리에서 불러온 이미지 리스트
  List<AssetEntity> _mediaList = [];

  // 앱 내에서 찍은 사진 저장 리스트
  List<String> _appSavedImages = [];

  // 사용자가 선택한 이미지 경로 저장
  Set<String> _selectedImages = {};

  // 최근 항목만 볼지 전체 앨범까지 볼지 토글
  bool _onlyRecent = true;

  // 권한을 확인했는지 여부
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    // 페이지 초기화 시 권한 체크 및 갤러리 로드
    _checkPermissionAndLoad();
  }

  // 권한 체크 후 갤러리 로드
  Future<void> _checkPermissionAndLoad() async {
    if (_permissionChecked) return; // 이미 체크했다면 다시 하지 않음

    final ps = await PhotoManager.requestPermissionExtend(); // 권한 요청

    if (ps.isAuth || ps.hasAccess) {
      // 전체 접근 또는 선택적 접근 허용
      _permissionChecked = true; // 권한 체크 완료
      _loadGallery(); // 갤러리 불러오기
    } else {
      // 권한 거부 → 설정 화면으로 이동
      await PhotoManager.openSetting();
    }
  }

  // 갤러리 불러오기
  Future<void> _loadGallery() async {
    // 모든 이미지 앨범 가져오기
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    List<AssetEntity> media;
    if (_onlyRecent) {
      // 최근 100개만 가져오기
      media = await albums.first.getAssetListPaged(page: 0, size: 100);
    } else {
      // 전체 가져오기 (최대 10000)
      media = await albums.first.getAssetListPaged(page: 0, size: 10000);
    }

    setState(() {
      _mediaList = media; // 화면 갱신
    });
  }

  // 이미지 선택/선택 해제 토글
  void _toggleSelection(String path) {
    setState(() {
      if (_selectedImages.contains(path)) {
        _selectedImages.remove(path);
      } else {
        _selectedImages.add(path);
      }
    });
  }

  // 최근 항목 보기 토글
  void _toggleRecent() {
    setState(() {
      _onlyRecent = !_onlyRecent;
    });
    _loadGallery(); // 갤러리 다시 로드
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("갤러리 선택", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // 상단 최근 항목 토글 버튼
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
          // 갤러리/앱 내 사진 Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(0),
              itemCount:
                  _mediaList.length + _appSavedImages.length + 1, // +1: 카메라 버튼
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3열
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1, // 정사각형
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 카메라 버튼
                  return GestureDetector(
                    onTap: () async {
                      try {
                        final cameras = await availableCameras(); // 기기 카메라 가져오기
                        if (cameras.isNotEmpty) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CameraPage(
                                camera: cameras.first,
                              ), // CameraPage로 이동
                            ),
                          );
                          if (result != null && result is String) {
                            // 찍은 사진 경로 저장
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

                // 이미지 표시
                Widget imageWidget;
                String path;

                if (index <= _appSavedImages.length) {
                  // 앱 내에서 찍은 사진
                  path = _appSavedImages[index - 1];
                  imageWidget = Image.file(File(path), fit: BoxFit.cover);
                } else {
                  // 갤러리 사진
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
                      return Container(color: Colors.black12); // 로딩 중 빈 박스
                    },
                  );
                }

                final isSelected = _selectedImages.contains(path);

                // 선택 표시
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
      // 선택한 이미지 등록 버튼
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
