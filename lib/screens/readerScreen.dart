import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ReaderScreen extends StatefulWidget {
  final String imageRoute;

  const ReaderScreen({Key key, this.imageRoute}) : super(key: key);

  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  var text = '';
  bool imageLoaded = false;

  Future pickImage() async {
    setState(() {
      imageLoaded = true;
    });
    FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(widget.imageRoute);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + ' ';
          });
        }
        text = text + '\n';
      }
    }
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                  child:
                      Image.file(File(widget.imageRoute), fit: BoxFit.cover)),
            ),
            Center(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.lightBlue)),
                color: Colors.lightBlue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: () async {
                  pickImage();
                },
                child: Text(
                  "Read".toUpperCase(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: text == ''
                  ? Text('Text will display here')
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SelectableText(
                            text,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
