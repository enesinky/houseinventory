import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/widgets/appbar.dart';


class ItemViewPage extends StatelessWidget {
  static const String route = '/Item';
  final int locationId;
  final int itemId;
  Item item;

  ItemViewPage(this.locationId, this.itemId) {
    // itemLocation = ProcessData.locationData
    //     .firstWhere((element) => (this.locationId == element.id))
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('test'),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Welcome to item + ' + this.itemId.toString())
            ],
          ),
        ));
  }
}
