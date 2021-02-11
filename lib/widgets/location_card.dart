import 'package:houseinventory/pages/inventory/location_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LocationCard extends StatelessWidget {
  final String name;
  final int itemCount;
  final int _locationId;

  LocationCard(this.name, this.itemCount, this._locationId);

  @override
  Widget build(BuildContext context) {
    var boxSize = (MediaQuery.of(context).size.width * 0.9 - 32) / 2;
    return Container(
      width: boxSize,
      height: boxSize,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(boxSize)),
        splashColor: Colors.amber,
        hoverColor: Colors.yellow,
        onTap: () {
          var navigateUrl = LocationViewPage.route + '/' + _locationId.toString();
          Navigator.pushNamed(context, navigateUrl);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color:Colors.white.withOpacity(0.5), width: 1),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade300.withOpacity(0.7)],),
              borderRadius: BorderRadius.all(Radius.circular(boxSize))
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                      ),

                    )
                  ]),
              SizedBox(height: 4,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                          child: Text(
                            itemCount.toString() + (itemCount < 2 ? ' item' : ' items.'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black38, fontSize: 14),
                          )
                      ),

                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
