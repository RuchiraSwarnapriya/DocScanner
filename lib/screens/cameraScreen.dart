import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:image_to_pdf/screens/previewScreen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
  CameraController controller;

  @override
  void initState() {
    List cameras;
    int selectedCameraIdx;

    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _cameraPreviewWidget(),
                ),
              ],
            ),
          )),
          Positioned(
            bottom: 30,
            left: 50,
            right: 50,
            child: IconButton(
                icon: Icon(Icons.camera_alt),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  _onCapturePressed(context);
                }),
          ),
        ],
      ),
    );
  }

  // Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void _onCapturePressed(context) async {
    try {
      final imgPath = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      print(imgPath);
      await controller.takePicture(imgPath);

      // Create a new PDF document
      final pw.Document pdf = new pw.Document();

      // Create pdf image from the captured image and add it as a page to the pdf document
      final image =
          PdfImage.file(pdf.document, bytes: File(imgPath).readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#ADD8E6')),
          // Do the decoration as needed
          padding: pw.EdgeInsets.all(10),
          child: pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.fill),
          ),
        );
      }));

      // Creating a temp file and save the pdf to that path
      final pdfPath = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.pdf',
      );
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(pdf.save());
      print(pdfPath);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(pdfPath, imgPath),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);
    print('Error: ${e.code}\n${e.description}');
  }
}
