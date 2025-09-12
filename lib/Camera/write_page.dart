import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera/camera.dart';
import 'camera_page.dart';

class WritePage extends StatelessWidget {
  final List<File> selectedImages;

  const WritePage({super.key, required this.selectedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("글쓰기")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Image.file(selectedImages[index], fit: BoxFit.cover);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "여기에 글을 작성하세요...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
