import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraView extends StatelessWidget {

  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => CameraView(),
  );

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
      toolbarHeight: 0,
      backgroundColor: Colors.amber,
      brightness: Brightness.dark

    ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('This is Camera view')],
            )));
  }

}