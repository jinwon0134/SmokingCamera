import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;
  const DisplayPicturePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('미리보기')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
