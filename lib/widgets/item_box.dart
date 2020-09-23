import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  final String itemName;

  ItemBox(this.itemName);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: InkWell(
        splashColor: Colors.amberAccent,
        onDoubleTap: () => print('double tapped'),
        child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
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
                          Text(itemName,
                              style: TextStyle(
                                fontSize: 20,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      )
                    ],
                  ))
          ),
    );
  }
}
