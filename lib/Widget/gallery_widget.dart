import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // File() 위젯 사용을 위한 모듈

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  // 선택한 파일
  XFile? phoneFile;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // 제스쳐 검사기
          GestureDetector(
            // 탭(터치) 제스쳐 콜백 정의, 그 밖에 길게 누르기, 드레그 등 여러가지
            onTap: fileSelect,
            // 제스쳐 영역의 UI
            child: const Text(
              '갤러리 선택',
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
          ),
          //     // 파일 선택 여부에 따라
          (phoneFile == null)
              // 안내 문구 또는
              ? const Text('선택 파일이 없습니다. 갤러리 선택을 누르세요')
              // 이미지 표시
              : Expanded(child: Image.file(File(phoneFile!.path))),
        ],
      ),
    );
  }

  // 갤러리 선택 터치시 콜백 함수
  // 내부에서 await 사용 위해 async 함수로 정의
  void fileSelect() async {
    // 이미지 선택, 선택완료까지 대기
    final file = await ImagePicker().pickImage(
      // 폰의 갤러리 폴더를 기본 선택
      // ImageSource.gallery(갤러리), ImageSource.camera(카메라)
      source: ImageSource.gallery,
    );
    // 파일을 선텍한 경우만
    if (file != null) {
      // 선택 파일 변경
      phoneFile = XFile(file.path);
      // UI 갱신을 위해 빈 setState 호출
      setState(() {});
    }
  }
}
