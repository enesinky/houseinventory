import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingGroupLabel extends StatelessWidget {
  final String label;

  SettingGroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 15, 0, 0),
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(label, style:
        TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),)],
      ),
    );
  }
}