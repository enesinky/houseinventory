import 'file:///D:/AndroidStudioProjects/house_inventory/lib/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemViewPage extends StatelessWidget {
    static const String route = '/Location';
    final int locationId;
    ItemViewPage(this.locationId);

  @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: CustomAppBar('Inventory List ' + locationId.toString()),
    body: Center(
    child: RaisedButton(
    onPressed: () {
    Navigator.pop(context);
    },
    child: Text('Go back! ' + locationId.toString()),
        ),
      ),
    );
  }
}
