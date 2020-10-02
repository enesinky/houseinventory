import 'package:houseinventory/data/process_data.dart';
import 'package:houseinventory/widgets/loading_dialog.dart';

  import '../../widgets/appbar.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  class InventoryViewPage extends StatelessWidget {
    static const String route = '/Inventory';

  @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: CustomAppBar('Inventory List'),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AddPlaceDialog();
                  });
            },
            //label: Text('Place'),
            mini: true,
            splashColor: Colors.blue,
            elevation: 1,
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.blueGrey,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Center(
              child:
              Column(
                children: [
                  Expanded(
                      child:
                      ListView(
                          scrollDirection: Axis.vertical,
                          //padding: EdgeInsets.all(16),
                          children: ProcessData.locationDataCards

                      ))
                  ],
              ))
      );
    }

  }


  class AddPlaceDialog extends StatefulWidget {
    @override
    _AddPlaceDialogState createState() => _AddPlaceDialogState();
  }

  class _AddPlaceDialogState extends State<AddPlaceDialog> {

    bool isLoading = false;

    TextEditingController textEditingController = new TextEditingController();

    _submitForm() {

      if (textEditingController.text.toString().length > 0) {
        Map<String, dynamic> jsonRaw = {
          "key": "inventory_page",
          "key2": 123,
          "key3": "xyz",
          "place": textEditingController.text.toString()
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

    _dialogTextFieldDecoration() {
      return InputDecoration(
        enabled: true,
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
        hintText: "Place name",

      );
    }

    @override
    Widget build(BuildContext context) {

      return isLoading ? CustomLoadingDialog.widget : AlertDialog(
              elevation: 12,
              scrollable: true,
              //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              title: Text('Add New Place to Inventory ', style: TextStyle(
                fontSize: 16,
              )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              actionsPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: [
                    TextField(
                      maxLines: 1,
                      maxLength: 30,
                      autofocus: true,
                      autocorrect: true,
                      controller: textEditingController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 14),
                      decoration: _dialogTextFieldDecoration(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.amber,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
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
                )
              ],
            );
    }
  }





