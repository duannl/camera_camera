import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File val;
  var _cameraDirection = CameraLensDirection.front;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () async {
              final file = await showDialog(
                  context: context,
                  builder: (context) => Camera(
                        mode: CameraMode.fullscreen,
                        initialCamera: _cameraDirection == CameraLensDirection.front ? CameraSide.front : CameraSide.back,
                        enableCameraChange: true,
                        orientationEnablePhoto: CameraOrientation.portrait,
                        onChangeCamera: (direction, _) {
                          _cameraDirection = direction;
                          print('--------------');
                          print('$direction');
                          print('--------------');
                        },

                        // imageMask: CameraFocus.square(
                        //   color: Colors.black.withOpacity(0.5),
                        // ),
                      ));
              if (_cameraDirection == CameraLensDirection.front && file != null) {
                val = await _bakeOrientation(file: file);
              } else {
                val = file;
              }
              
              setState(() {});
            }),
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.8,
                child: val != null
                    ? Image.file(
                        val,
                        fit: BoxFit.contain,
                      )
                    : Text("Tire a foto"))));
  }

  // to make sure orientation is correct
  // https://stackoverflow.com/a/62807277/2721547
  Future<File> _bakeOrientation({File file}) async {
    img.Image capturedImage = img.decodeImage(await file.readAsBytes());
    img.Image orientedImage = img.bakeOrientation(capturedImage);
    return File(file.path).writeAsBytes(img.encodeJpg(orientedImage));
  }
}
