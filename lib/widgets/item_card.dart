import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/util/shared_prefs.dart';

import '../application.dart';

// ignore: must_be_immutable
class ItemBox extends StatefulWidget {
  final Item item;
  final Function(int) onLongPress;
  final Function(int) onTap;
  bool isSelected;
  Function refresh;

  final List<Color> _circleColors = [
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

  final Color _defaultColor = Colors.amber.shade600;

  ItemBox({
    @required this.item,
    @required this.isSelected,
    @required this.onLongPress,
    @required this.onTap,
  });

  @override
  _ItemBoxState createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  refreshWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.refresh = refreshWidget;
    Color boxColor;
    if (sharedPrefs.getBool("randomItemColor") == true) {
      boxColor = widget._circleColors[widget.item.iid.toInt() % 10];
    } else {
      boxColor = widget._defaultColor;
    }


    String langCode = sharedPrefs.getString(applic.languageSharedPref);

    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    var dateText;
    DateTime dateCreated = DateTime.parse(widget.item.created);
    //DateTime dateModified = DateTime.parse(widget.item.modified);
    final currentTime = new DateTime.now();
    var createdTa = timeago.format(
        currentTime.subtract(Duration(
            milliseconds: currentTime.millisecondsSinceEpoch -
                dateCreated.millisecondsSinceEpoch)), locale: langCode);
    // var modifiedTa = timeago.format(
    //     currentTime.subtract(Duration(
    //         milliseconds: currentTime.millisecondsSinceEpoch -
    //             dateModified.millisecondsSinceEpoch)),
    //     locale: sharedPrefs.getString(applic.languageSharedPref));

    // dateText = (widget.item.modified == widget.item.created)
    //     ? t.text("items_created_msg", {"timeago": createdTa})
    //     : t.text("items_modified_msg", {"timeago": modifiedTa});

    dateText = Translations.of(context).text("items_created_msg", {"timeago": createdTa});

    var boxDecoration = widget.isSelected
        ? BoxDecoration(
            gradient: LinearGradient(
                colors: [boxColor.withOpacity(0.9), boxColor.withOpacity(0.3)]),
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(4)))
        : BoxDecoration(
            gradient: LinearGradient(
                colors: [boxColor.withOpacity(0.9), boxColor.withOpacity(0.3)]),
            border: Border.all(color: boxColor.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)));

    return Container(
      width: (MediaQuery.of(context).size.width * 0.9 - 16) / 2,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
          splashColor: Colors.amber,
          onLongPress: () => {widget.onLongPress(widget.item.iid)},
          onTap: () => {widget.onTap(widget.item.iid)},
          highlightColor: Colors.amberAccent.shade100,
          child: Container(
            decoration: boxDecoration,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        child: Flexible(
                            child: Text(
                          dateText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 11,
                              fontStyle: FontStyle.italic),
                        )),
                      )
                    ]),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          child: Flexible(
                              child: Text(widget.item.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54))),
                        )
                      ],
                    )
                  ],
                )),
          )),
    );
  }
}
