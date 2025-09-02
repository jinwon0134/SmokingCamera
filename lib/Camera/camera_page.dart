import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'display_picture_page.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  const CameraPage({super.key, required this.camera});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _initializeControllerFuture;
          final image = await _controller.takePicture();

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPicturePage(imagePath: image.path),
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
