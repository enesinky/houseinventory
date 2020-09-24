import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:houseinventory/pages/inventory/item_view.dart';
class ItemBox extends StatelessWidget {
  final int locationId;
  final String itemName;
  final int itemId;

  ItemBox(this.locationId, this.itemName, this.itemId);

  @override
  Widget build(BuildContext context) {
    var navigateUrl = ItemViewPage.route + '/' + this.locationId.toString() + '/' + this.itemId.toString();
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
      height: 73,
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
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2),
              border: Border.all(color:Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.1), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(
                            "Added on Monday",
                            style: TextStyle(
                                color: Colors.black87,
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
                                    fontSize: 20,
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
