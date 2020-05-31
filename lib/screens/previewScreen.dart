import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PreviewImageScreen extends StatefulWidget {
  final String pdfPath;

  PreviewImageScreen(this.pdfPath);

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  @override
  Widget build(BuildContext context) {
    // User pdfViewer to preview the generated pdf by giving the pdf link
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              child: PDFViewerScaffold(
            appBar: AppBar(
              title: Text('Preview'),
              backgroundColor: Colors.lightBlue,
            ),
            path: widget.pdfPath,
          )),
        ],
      ),
    );
  }
}
