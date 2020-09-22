import 'package:houseinventory/data/inventory_data.dart';

  import '../../ui/appbar.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  class InventoryPage extends StatelessWidget {
    static const String route = '/Inventory_List';

  @override
    Widget build(BuildContext context) {
      //Inventory().getLocations();
      //print(LocationData.locationData);
      return Scaffold(
          appBar: CustomAppBar('Inventory List'),
          body: Center(
              child:
              Column(
                children: [
                  Expanded(
                      child:
                      ListView(
                          scrollDirection: Axis.vertical,
                          //padding: EdgeInsets.all(16),
                          children: LocationData.locationDataCards
                          // <Widget>[
                          //   LocationCard('Bedroom', 12, 1),
                          //   LocationCard('Kitchen', 105, 2),
                          //   LocationCard('Bed Base', 16, 3),
                          //   LocationCard('TV Unit', 2, 4),
                          //   LocationCard('Basement', 55, 5),
                          //   LocationCard('Small Room Sofa', 7, 6)
                          // ]
                      ))
                  ],
              ))
      );
    }
  }




