import 'package:houseinventory/data/process_data.dart';

  import '../../widgets/appbar.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  class InventoryViewPage extends StatelessWidget {
    static const String route = '/Inventory';

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
                          children: ProcessData.locationDataCards

                      ))
                  ],
              ))
      );
    }
  }




