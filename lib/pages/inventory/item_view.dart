import 'file:///D:/AndroidStudioProjects/house_inventory/lib/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/data/process_data.dart';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/model/item_location.dart';
import 'package:houseinventory/widgets/item_box.dart';
import 'package:houseinventory/widgets/search_box.dart';


class ItemViewPage extends StatelessWidget {
  static const String route = '/Location';
  final int locationId;
  ItemLocation itemLocation;
  List<Widget> itemBoxes = List<Widget>();

  ItemViewPage(this.locationId) {
    itemLocation = ProcessData.locationData
        .firstWhere((element) => (this.locationId == element.id));
      if(itemLocation.items.length > 0) {
          itemBoxes.add(SearchBox());
        itemLocation.items.forEach((Item item) {
          itemBoxes.add(ItemBox(item.name));
        });
      }
      else {
        itemBoxes = [Container()];
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(itemLocation.name),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: this.itemBoxes,
            // children: [
            //   SearchBox(),
            //
            // ],
          ),
        ));
  }
}
