import 'ui/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {

  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => SearchPage(),
  );

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CustomAppBar('Search Items'),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('This is search page')],
            )));
  }

}