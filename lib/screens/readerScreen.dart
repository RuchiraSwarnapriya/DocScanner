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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Preview'),
    //     backgroundColor: Colors.lightBlue,
    //   ),
    //   body: Container(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: <Widget>[
    //         Container(
    //             margin: const EdgeInsets.all(40.0),
    //             width: 300,
    //             height: 300,
    //             child: Image.file(File(widget.imageRoute), fit: BoxFit.cover)),
    //         SizedBox(height: 10.0),
    //         // Flexible(
    //         //   flex: 1,
    //         //   child: Container(
    //         //     padding: EdgeInsets.all(60.0),
    //         //     child: RaisedButton(
    //         //       onPressed: () {
    //         //         getBytesFromFile().then((bytes) {
    //         //           Share.file('Share via:', basename(widget.imagePath),
    //         //               bytes.buffer.asUint8List(), 'image/png');
    //         //         });
    //         //       },
    //         //       child: Text('Share'),
    //         //     ),
    //         //   ),
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(40.0),
              width: 300,
              height: 300,
              child: Image.file(File(widget.imageRoute), fit: BoxFit.cover)),
          SizedBox(height: 10.0),
          Center(
            child: FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                size: 100,
              ),
              label: Text(''),
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                pickImage();
              },
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
          text == ''
              ? Text('Text will display here')
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        text,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
