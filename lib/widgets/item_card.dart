import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/pages/inventory/item_view.dart';



// ignore: must_be_immutable
class ItemBox extends StatelessWidget {
  final Item item;
  Color boxColor;

  ItemBox(this.item) {
    //randomColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
    List<Color> circleColors = [
      Colors.red.shade700,
      Colors.red.shade500,
      Colors.red.shade300,
      Colors.amber.shade900,
      Colors.amber.shade700,
      Colors.amber.shade600,
      Colors.deepOrangeAccent,
      Colors.deepOrange.shade500,
      Colors.blueGrey.shade400,
      Colors.blueGrey.shade500
    ];
    if(sharedPrefs.getBool("randomItemColor") == true) {
      boxColor = circleColors[item.iid.toInt() % 10];
    } else {
      boxColor = Colors.amber.shade600;
    }

    //randomColor = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    var navigateUrl = ItemViewPage.route + '/' + this.item.iid.toString();
    //var randomDate = new DateTime.parse(2020, DateTime.november, math.Random().nextInt(30));
    var dateText;
    DateTime dateCreated = DateTime.parse(this.item.created);
    DateTime dateModified = DateTime.parse(this.item.modified);

    final currentTime = new DateTime.now();
    var createdTa = timeago.format(
        currentTime.subtract(Duration(milliseconds: currentTime.millisecondsSinceEpoch - dateCreated.millisecondsSinceEpoch)),
        locale: 'en');
    var modifiedTa = timeago.format(
        currentTime.subtract(Duration(milliseconds: currentTime.millisecondsSinceEpoch - dateModified.millisecondsSinceEpoch)),
        locale: 'en');

    dateText = (item.modified == item.created) ? "Created $createdTa" : "Modified $modifiedTa";

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
      width: (MediaQuery.of(context).size.width * 0.9 - 16) / 2,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        splashColor: Colors.amber,
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
              gradient: LinearGradient(colors: [boxColor.withOpacity(0.9), boxColor.withOpacity(0.3)]),
              border: Border.all(color:this.boxColor.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Container(
                            child: Flexible(
                              child: Text(
                                dateText,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              )
                            ),

                          )
                        ]),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              child: Flexible(
                                  child: Text(this.item.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54
                                      ))
                              ),
                            )

                          ],
                        )
                      ],
                    )),
        )
          ),
    );
  }
}
