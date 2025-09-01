import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;
  const DisplayPicturePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Image.file(File(imagePath)),
    );
  }
}
