import 'package:flutter/material.dart';
import 'package:nativejavacode/camara.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Miniature photo1 = new Miniature(),
      photo2 = new Miniature(),
      photo3 = new Miniature();
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
            children: <Widget>[photo1, photo2, photo3],
          )),
    );
  }
}
