// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// class GalleryWidget extends StatefulWidget {
//   @override
//   _GalleryWidgetState createState() => _GalleryWidgetState();
// }

// class  _GalleryWidgetState extends State<GalleryWidget> {
//   XFile? _image; // 선택한 이미지를 담을 변수
//   final ImagePicker picker = ImagePicker(); // ImagePicker 인스턴스 생성

//   // 갤러리에서 이미지를 가져오는 함수
//   Future getImageGallery() async {
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택

//     setState(() {
//       if (pickedFile != null) {
//         _image = pickedFile; // 선택된 이미지를 _image 변수에 저장
//       }
//     });
//   }

//   // 카메라에서 이미지를 가져오는 함수
//   Future getImageCamera() async {
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택

//     setState(() {
//       if (pickedFile != null) {
//         _image = pickedFile; // 선택된 이미지를 _image 변수에 저장
//       }
//     });
//   }
// }
