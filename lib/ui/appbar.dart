import 'dart:ui';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  CustomAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text('Lets view profile'));
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[IconButton(
        icon: Icon(Icons.account_circle, size: 35, color: Colors.black), onPressed: () {
        Scaffold.of(context).showSnackBar(snackBar);
      },
      )],
      toolbarHeight: 60,
      backgroundColor: Colors.amber,
      brightness: Brightness.dark,
      toolbarOpacity: 0.9,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.amber,
                  Colors.blue
                ])
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
