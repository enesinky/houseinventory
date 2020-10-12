import 'file:///D:/AndroidStudioProjects/house_inventory/lib/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/data/process_data.dart';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/model/item_location.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/widgets/item_card.dart';
import 'package:houseinventory/widgets/loading_dialog.dart';
import 'package:houseinventory/widgets/search_box.dart';

class LocationViewPage extends StatelessWidget {
  static const String route = '/Location';
  final int locationId;
  ItemLocation itemLocation;
  List<Widget> itemBoxes = List<Widget>();
  LocationViewPage(this.locationId) {
    itemLocation = ProcessData.itemsData
        .firstWhere((element) => (this.locationId == element.id));
    if (itemLocation.items.length > 0) {
      itemLocation.items.forEach((Item item) {
        itemBoxes.add(ItemBox(itemLocation.id, item.name, item.id));
      });
    }
    else {
      itemBoxes = [Container()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(itemLocation.name + ' Items'),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AddItemDialog(itemLocation);
                });
            //_displayDialog(context);
          },
          label: Text('Item', style: TextStyle(color: Colors.black54)),
          splashColor: Colors.blue,
          elevation: 16,
          icon: Icon(Icons.add_circle, color: Colors.black),
          backgroundColor: Colors.amber,
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              SearchBox(),
              itemLocation.items.length > 0 ? Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: itemLocation.items.length * 88.0,
                    // or something simular :)
                    child: new Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Expanded(
                          child: Column(
                            children: this.itemBoxes,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30),
                child: Text('No item yet.', style: TextStyle(fontSize: 17),),
              ),
            ],
          ),
        ));
  }
}

class AddItemDialog extends StatefulWidget {
  ItemLocation itemLocation;
  AddItemDialog(this.itemLocation);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  bool isLoading = false;
  _dialogTextFieldDecoration(int index) {
    return InputDecoration(
      enabled: true,
      counter: SizedBox.shrink(),
      //isDense: true,
      contentPadding: EdgeInsets.all(10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 2),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      hintText: "#" + index.toString() + " Item name",
      hintStyle: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.2))

    );
  }

  // initialize controllers with only one item
  List<TextEditingController> controllers = [
    new TextEditingController()
  ];
  List<Widget> _createChildren() {
    // toggle autofocus for first element
    bool autoFocus;
    controllers.length > 1 ? autoFocus = false : autoFocus = true;
    // create widgets
    return new List<Widget>.generate(controllers.length, (int index) {
      return TextField(
        textCapitalization: TextCapitalization.words,
        autofocus: autoFocus,
        controller: controllers[index],
        maxLines: 1,
        maxLength: 30,
        autocorrect: true,
        textInputAction: TextInputAction.next,
        style: TextStyle(fontSize: 14),
        decoration: _dialogTextFieldDecoration(1 + index),
      );
    });
  }
  _submitForm() {

    // validate at least 1 field is not empty
    bool isValid = false;
    
    // read items from text field and add it to a list
    List<String> itemNames = List<String>();
    controllers.forEach((element) {
      if(element.text.toString().length > 0) {
        isValid = true;
        itemNames.add(element.text.toString());
      }
    });

    if (isValid) {
      Map<String, dynamic> jsonRaw = {
        "key": "abc",
        "key2": 123,
        "key3": "xyz",
        "items": itemNames
      };
      print(jsonRaw);

      setState(() {
        isLoading = true;
      });
      new Future.delayed(new Duration(seconds: 3), () {
        Navigator.pop(context); //pop dialog
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? CustomLoadingDialog.widget : AlertDialog(
      elevation: 12,
      scrollable: true,
      //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      title: Text('Add Items to ' + widget.itemLocation.name, style: TextStyle(
        fontSize: 16,
      )),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      actionsPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Column(
          children: [
            Column(
              children: _createChildren(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => {
                if(controllers.length < Constants.MAX_ADD_ITEM_LIMIT) {
                  setState(() {
                    controllers.add(new TextEditingController());
                  }),
                  Future.delayed(const Duration(milliseconds: 50), () {
                    setState(() {
                      FocusScope.of(context).nextFocus();
                    });
                  })
                }
                },
                splashColor: Colors.amber,
                child: Container(
                  height: 30,
                  width: 56,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.amber),
                      Text('Add', style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2
                      ),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 40,),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                splashColor: Colors.amber,
                child: Container(
                  width: 56,
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  child: Text('Cancel', style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //side: BorderSide(color: Colors.red)
                ),
                child: new Text('Done'),
                color: Colors.blue,
                onPressed: () {
                  _submitForm();
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}