import 'ui/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => Dashboard(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Dashboard'),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('bla bla bla')],
            )),
        );
  }
}