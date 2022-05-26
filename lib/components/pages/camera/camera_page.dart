import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  CameraController? cameraController;

  Future<void> openCamera() async {
    try {
      cameraController = CameraController(
          _cameras.length == 2 ? _cameras[1] : _cameras[0],
          ResolutionPreset.max);
      await cameraController!.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    _initCamera(_cameras.first);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    cameraController =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await cameraController!.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = cameraController!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  void initCamera() async {
    _cameras = await availableCameras();
    await openCamera();
  }

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null) {
      return Container();
    }

    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CameraPreview(cameraController!),
            ),
          ),
          _shotContainer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleCameraLens();
        },
        child: const Icon(
          Icons.cameraswitch_outlined,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: const BackButton(),
    );
  }

  Container _shotContainer() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final image = await cameraController!.takePicture();

              Navigator.of(context).pop(File(image.path));
            },
            child: Container(
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black26,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
