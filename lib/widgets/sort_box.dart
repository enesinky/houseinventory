import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/shared_prefs.dart';

class SortBox extends StatefulWidget {
  final List<String> sortingOptions;
  final List<dynamic> orderingOptions;
  final Function(int, int) onSortChange;
  final String sortMethodSharedPref;
  final String orderMethodSharedPref;

  SortBox(
      {@required this.sortingOptions,
      @required this.orderingOptions,
      @required this.onSortChange,
      @required this.sortMethodSharedPref,
      @required this.orderMethodSharedPref});

  @override
  _SortBoxState createState() => _SortBoxState();
}

class _SortBoxState extends State<SortBox> {
  @override
  Widget build(BuildContext context) {
    var t = Translations.of(context);
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      splashColor: Colors.blueAccent,
      highlightColor: Colors.amber,
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return SortDialog(
                onSelectionChange: (int sort, int order) {
                  widget.onSortChange(sort, order);
                },
                sortByOptions: widget.sortingOptions,
                orderByOptions: widget.orderingOptions,
                sortMethodSharedPref: widget.sortMethodSharedPref,
                orderMethodSharedPref: widget.orderMethodSharedPref,
              );
            });
      },
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.text("sort").toUpperCase(),
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.sort_by_alpha,
              size: 22,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}

class SortDialog extends StatefulWidget {
  final List<String> sortByOptions;
  final List<dynamic> orderByOptions;
  final Function(int, int) onSelectionChange;
  final String sortMethodSharedPref;
  final String orderMethodSharedPref;

  SortDialog(
      {@required this.sortByOptions,
      @required this.orderByOptions,
      @required this.onSelectionChange,
      @required this.sortMethodSharedPref,
      @required this.orderMethodSharedPref});

  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  List<String> presentedOrderMethods = [];

  @override
  void initState() {
    super.initState();
    updateOrderMethodText();
  }

  updateOrderMethodText() {
    var selectedIndex = sharedPrefs.getInt(widget.sortMethodSharedPref);
    var orderMethodPair = widget.orderByOptions[selectedIndex];
    setState(() {
      presentedOrderMethods = [
        orderMethodPair[0].toString(),
        orderMethodPair[1].toString()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = Translations.of(context);
    return AlertDialog(
      elevation: 30,
      scrollable: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 80),
      content: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.96,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 70,
                      child: Text(
                        t.text("sort_by"),
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )),
                  // ignore: missing_required_param
                  Container(
                    width: 150,
                    child: DropdownButton<String>(
                      icon: Icon(Icons.sort),
                      isExpanded: true,
                      iconEnabledColor: Colors.amber,
                      dropdownColor: Colors.amberAccent,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.black12,
                      ),
                      items: widget.sortByOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: widget.sortByOptions[
                              sharedPrefs.getInt(widget.sortMethodSharedPref)]
                          .toString(),
                      onChanged: (String newValue) {
                        setState(() {
                          var i = widget.sortByOptions.indexOf(newValue);
                          sharedPrefs.setInt(widget.sortMethodSharedPref, i);

                          var j =
                              sharedPrefs.getInt(widget.orderMethodSharedPref);
                          widget.onSelectionChange(i, j);

                          var orderByMethod = widget.orderByOptions[i];
                          presentedOrderMethods = [
                            orderByMethod[0].toString(),
                            orderByMethod[1].toString()
                          ];
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 70,
                      child: Text(
                        t.text("order_by"),
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )),
                  // ignore: missing_required_param
                  Container(
                    width: 150,
                    child: DropdownButton<String>(
                      icon: Icon(Icons.sort),
                      isExpanded: true,
                      iconEnabledColor: Colors.amber,
                      dropdownColor: Colors.amberAccent,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: Colors.black12,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: "asc",
                          child: Text(presentedOrderMethods[0]),
                        ),
                        DropdownMenuItem<String>(
                          value: "desc",
                          child: Text(presentedOrderMethods[1]),
                        )
                      ],
                      value:
                          sharedPrefs.getInt(widget.orderMethodSharedPref) == 0
                              ? "asc"
                              : "desc",
                      onChanged: (String newValue) {
                        setState(() {
                          var i =
                              sharedPrefs.getInt(widget.sortMethodSharedPref);
                          var j = newValue == "asc" ? 0 : 1;
                          sharedPrefs.setInt(widget.orderMethodSharedPref, j);
                          widget.onSelectionChange(i, j);
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
