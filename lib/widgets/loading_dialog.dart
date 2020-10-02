import 'package:flutter/material.dart';

class CustomLoadingDialog {

  static var _widget = Dialog(
    child: Center(
      heightFactor: 1.6,
      widthFactor: 1,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          SizedBox(height: 24,),
          new Text("Loading", style: TextStyle(
              color: Colors.black54,
              fontSize: 15
          ),),
        ],
      ),
    ),
  );

  static get widget => _widget;
}