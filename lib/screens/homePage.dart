import 'package:flutter/material.dart';

import 'package:image_to_pdf/screens/cameraScreen.dart';

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
