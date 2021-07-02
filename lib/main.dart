import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nativejavacode/camara.dart';
import 'postprocessing.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Miniature photo1 = new Miniature();

  bool preloaded = false;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              photo1,
              FlatButton(
                  onPressed: () {
                    setImage(photo1);
                  },
                  child: Text('Hola')),
              preloaded
                  ? Image.file(File(photo1.globalpath))
                  : Image.file(File(
                      '/data/user/0/com.example.nativejavacode/cache/2021-06-3020:04:51.261523.png'))
            ],
          )),
    );
  }

  void setImage(Miniature photo1) {
    preloaded = true;
    setState(() {
      segmentHSV(photo1.globalpath);
    });
  }
}
