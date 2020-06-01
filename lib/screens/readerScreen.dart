import 'dart:io';

import 'package:flutter/material.dart';

class ReaderScreen extends StatefulWidget {
  final String imageRoute;

  const ReaderScreen({Key key, this.imageRoute}) : super(key: key);

  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.file(File(widget.imageRoute), fit: BoxFit.cover)),
            SizedBox(height: 10.0),
            // Flexible(
            //   flex: 1,
            //   child: Container(
            //     padding: EdgeInsets.all(60.0),
            //     child: RaisedButton(
            //       onPressed: () {
            //         getBytesFromFile().then((bytes) {
            //           Share.file('Share via:', basename(widget.imagePath),
            //               bytes.buffer.asUint8List(), 'image/png');
            //         });
            //       },
            //       child: Text('Share'),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
