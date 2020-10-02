import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/data/process_data.dart';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/widgets/appbar.dart';


class ItemViewPage extends StatelessWidget {
  static const String route = '/Item';
  final int locationId;
  final int itemId;
  Item item;

  ItemViewPage(this.locationId, this.itemId) {
    item = ProcessData.itemsData
        .firstWhere((element) => (this.locationId == element.id))
        .items
        .firstWhere((element) => (this.itemId == element.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(item.name),
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
