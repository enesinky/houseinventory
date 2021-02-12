import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/util/shared_prefs.dart';

class SortBox extends StatefulWidget {

  final List<String> sortingOptions;
  final List<dynamic> orderingOptions;
  final Function(int, int) onSortChange;

  SortBox({
    @required this.sortingOptions,
    @required this.orderingOptions,
    @required this.onSortChange
  });


  static int selectedSortMethodIndex = sharedPrefs.getInt("itemsSortBy");
  static int selectedOrderMethodIndex = sharedPrefs.getInt("itemsOrderBy");
  static List<String> presentedOrderMethods = [];

  @override
  _SortBoxState createState() => _SortBoxState();

}

class _SortBoxState extends State<SortBox> {

  @override
  void initState() {
    super.initState();
    updateOrderMethodText();
  }

  updateOrderMethodText() {
    var orderMethodPair = widget.orderingOptions[sharedPrefs.getInt("itemsSortBy")];
    setState(() {
      SortBox.presentedOrderMethods = [orderMethodPair[0].toString(), orderMethodPair[1].toString()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 4),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          splashColor: Colors.blueAccent,
          highlightColor: Colors.amber,
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context)  {
                return SortDialog(
                  onSelectionChange: (int sort, int order) {
                    widget.onSortChange(sort, order);
                  },
                  sortByOptions: widget.sortingOptions,
                  orderByOptions: widget.orderingOptions,
                );
                });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort'.toUpperCase(),
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
        ));
  }
}


class SortDialog extends StatefulWidget {

  final List<String> sortByOptions;
  final List<dynamic> orderByOptions;
  final Function(int, int) onSelectionChange;

  SortDialog({
    @required this.sortByOptions,
    @required this.orderByOptions,
    @required this.onSelectionChange
  });

  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 30,
      scrollable: true,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
      //contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 80),
      content: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.90,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 70,
                      child: Text(
                        'Sort By:',
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
                      hint: Text('Select Place'),
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
                      value: widget.sortByOptions[SortBox.selectedSortMethodIndex].toString(),
                      onChanged: (String newValue) {
                        setState(() {
                          var i = widget.sortByOptions.indexOf(newValue);
                          var orderByMethod = widget.orderByOptions[i];

                          SortBox.selectedSortMethodIndex = i;
                          SortBox.presentedOrderMethods = [orderByMethod[0].toString(), orderByMethod[1].toString()];

                          widget.onSelectionChange(i, SortBox.selectedOrderMethodIndex);
                          sharedPrefs.setInt("itemsSortBy", i);
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
                        'Order:',
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
                          child: Text(SortBox.presentedOrderMethods[0]),
                        ),
                        DropdownMenuItem<String>(
                          value: "desc",
                          child: Text(SortBox.presentedOrderMethods[1]),
                        )
                      ],
                      value: SortBox.selectedOrderMethodIndex== 0 ? "asc" : "desc",
                      onChanged: (String newValue) {
                        setState(() {
                          var j = newValue == "asc" ? 0 : 1;
                          SortBox.selectedOrderMethodIndex = j;
                          widget.onSelectionChange(SortBox.selectedSortMethodIndex, j);
                          sharedPrefs.setInt("itemsOrderBy", j);
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
