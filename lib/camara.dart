import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';





// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toma la fotografía')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return new Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                new Positioned.fill(
                  child: new AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: new CameraPreview(_controller)),
                ),
                new Positioned.fill(
                  child: new Opacity(
                    opacity: 0.7,
                    child: new Image.asset(
                      'assets/images/overlaycamera.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            
            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            //print('hola.5');
            Navigator.pop(context,path);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class Miniature extends StatefulWidget {
  String globalpath;
  bool phototaken = false;
  @override
  State<StatefulWidget> createState() {
    return new _MiniatureState();
  }
}

class _MiniatureState extends State<Miniature> {
  //String _photoURI = 'assets/images/placeholder.png';
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.phototaken
            ? Image.file(File(widget.globalpath))
            : Image.asset('assets/images/placeholder.png'),
        FlatButton.icon(
          textColor: Color.fromRGBO(1, 133, 133, 1),
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            //print('hol');
            final path = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                ),
              ),
            );
            if (path!=null) {
              
              setState(() {
                //print('$path');
                widget.globalpath = path;
                widget.phototaken = true;
              });
            }
            
          },
          icon: Icon(Icons.camera, size: 18),
          label: Text('Tomar fotografía'),
        ),
      ],
    );
  }
}
