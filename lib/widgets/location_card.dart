import 'package:houseinventory/pages/inventory/item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String name;
  final int itemCount;
  final int _locationId;

  LocationCard(this.name, this.itemCount, this._locationId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      elevation: 12,
      borderOnForeground: true,
      color: Colors.blueGrey,
      child: InkWell(
        splashColor: Colors.redAccent.withAlpha(90),
        onTap: () {
          //print('Card tapped: ' + name + '. Location ID: ' + locationId.toString());
          var navigateUrl = ItemViewPage.route + '/' + _locationId.toString();
          Navigator.pushNamed(context, navigateUrl);
        },
        child: Container(
          alignment: Alignment.center,
          //width: MediaQuery.of(context).size.width * 0.9,
          height: 80,
          /*decoration: BoxDecoration(
            color: Colors.blueGrey,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.indigo,
            //     spreadRadius: 2,
            //     blurRadius: 2,
            //     offset: Offset(1, 5), // changes position of shadow
            //   ),
            // ]
            ),*/
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              Text(
                itemCount.toString() + ' items.',
                style: TextStyle(color: Colors.black38, fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
