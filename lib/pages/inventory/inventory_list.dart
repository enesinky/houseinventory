import 'package:covid19_mask/ui/cards/location_card.dart';

import 'ui/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => InventoryPage(),
  );

  @override
  Widget build(BuildContext context) {
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
                children: <Widget>[
                    LocationCard('Bedroom', 12),
                    LocationCard('Kitchen', 105),
                    LocationCard('Bed Base', 16),
                    LocationCard('TV Unit', 2),
                    LocationCard('Basement', 55),
                    LocationCard('Small Room Sofa', 7)
              ]
              ))
    ],
    ))
    );
  }
}