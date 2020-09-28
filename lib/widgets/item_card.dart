import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:houseinventory/pages/inventory/item_view.dart';

class ItemBox extends StatelessWidget {
  final int locationId;
  final String itemName;
  final int itemId;
  Color randomColor;

  ItemBox(this.locationId, this.itemName, this.itemId) {
    //randomColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
    List<Color> circleColors = [
      Colors.red.shade700,
      Colors.red.shade500,
      Colors.red.shade300,
      Colors.amber.shade900,
      Colors.amber.shade700,
    ];
    randomColor = circleColors[math.Random().nextInt(circleColors.length)];
    //randomColor = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    var navigateUrl = ItemViewPage.route + '/' + this.locationId.toString() + '/' + this.itemId.toString();
    var randomDate = new DateTime.utc(2020, DateTime.november, math.Random().nextInt(30));
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    var stringDay = days[randomDate.weekday - 1];
    final snackBarEditGuide = SnackBar(
      content: Text('Press Long to Edit the Item.', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),),
      duration: Duration(seconds: 1),
      elevation: 12.0,
      backgroundColor: Colors.amber,
    );


    return Container(
      height: 68,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: InkWell(
        splashColor: Colors.blue.shade200,
        onLongPress: () => {
          Navigator.pushNamed(context, navigateUrl)
        },
        onDoubleTap: () => {
          Scaffold.of(context).hideCurrentSnackBar(),
          Scaffold.of(context).showSnackBar(snackBarEditGuide)
        },
        highlightColor: Colors.amberAccent.shade100,
        child: Container(
          decoration: BoxDecoration(
              //color: this.randomColor.withOpacity(0.5),
              gradient: LinearGradient(colors: [randomColor.withOpacity(0.7), randomColor.withOpacity(0.3)]),
              border: Border.all(color:this.randomColor.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(
                            "Added on " + stringDay,
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ]),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Text(itemName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    )),
        )
          ),
    );
  }
}
