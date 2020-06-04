import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_to_pdf/screens/readerScreen.dart';
import 'package:path/path.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class PreviewImageScreen extends StatefulWidget {
  final String pdfPath;
  final String imageRoute;

  PreviewImageScreen(this.pdfPath, this.imageRoute);

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[98],
      appBar: new AppBar(
        title: Text(
          'PDF Preview',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: PdfViewer(
              filePath: widget.pdfPath,
            ),
          ),
          Positioned(
            bottom: 1,
            left: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReaderScreen(imageRoute: widget.imageRoute),
                  ),
                );
              },
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.chrome_reader_mode,
                    color: Colors.blue,
                    size: 25,
                  ),
                  Text(
                    "Read Pdf",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: 50,
            child: FlatButton(
              onPressed: () {
                getBytesFromFile().then(
                  (bytes) {
                    Share.file('Share via:', basename(widget.pdfPath),
                        bytes.buffer.asUint8List(), 'image/png');
                  },
                );
              },
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Colors.blue,
                    size: 25,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.pdfPath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}
