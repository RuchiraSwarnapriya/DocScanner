import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_to_pdf/screens/previewScreen.dart';
import 'package:edge_detection/edge_detection.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[98],
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 50,
            right: 50,
            top: 50,
            child: (Image.asset(
              'assets/app_logo_final.png',
              width: 1000,
            )),
          ),
          Positioned(
            bottom: 30,
            left: 50,
            right: 50,
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.white,
                onPressed: () {
                  _onCapturePressed(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCapturePressed(context) async {
    try {
      final imgPath = await EdgeDetection.detectEdge;

      final pw.Document pdf = new pw.Document();

      final image =
          PdfImage.file(pdf.document, bytes: File(imgPath).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
              decoration: pw.BoxDecoration(color: PdfColor.fromHex('#ADD8E6')),
              padding: pw.EdgeInsets.all(10),
              child: pw.Center(
                child: pw.Image(image, fit: pw.BoxFit.contain),
              ),
            );
          },
        ),
      );

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
}
