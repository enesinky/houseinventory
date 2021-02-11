import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/model/item.dart';
import '../../widgets/appbar.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/widgets/item_card.dart';
import 'package:houseinventory/widgets/loading_dialog.dart';
import 'package:houseinventory/widgets/search_box.dart';

// ignore: must_be_immutable
class LocationViewPage extends StatefulWidget {
  static const String route = '/Location';
  final int placeId;
  String locationName;

  LocationViewPage(this.placeId);

  @override
  _LocationViewPageState createState() => _LocationViewPageState();



}

class _LocationViewPageState extends State<LocationViewPage> {

  List<Widget> _itemBoxes = List<Widget>();
  String _appBarText = "";

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> _getItems() async {
    List<Widget> itemBoxes = List<Widget>();
    try {
      http.Response response = await http.post(
        Constants.apiURL + '/api/items/list',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "by": "modified",
          "pid": widget.placeId,
          "order": "DESC",
          "user_hash": sharedPrefs.getString("hash1")
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if(jsonData['result'] == true ){
          List<dynamic> items = jsonData['items'];
          for(var i = 0; i < items.length; i++) {
            var item = items[i];
            itemBoxes.add(new ItemBox(Item(item['name'].toString(), item['iid'], item['placeName'], item['created'], item['modified'])));
            if(i == items.length - 1) {
              setState(() {
                _itemBoxes = itemBoxes;
                widget.locationName = item['placeName'];
                _appBarText = item['placeName'];
              });
            }
          }
        }
        else {
          _requestError('Request Error.');
        }
      }
      else {
        _requestError('Request Error.');
      }
    } on SocketException catch(e) {
      _requestError('You are not connected to internet.');
      log(e.toString());
    }
    on TimeoutException catch(e) {
      _requestError('Server time out.');
      log(e.toString());
    }
    catch (exception) {
      _requestError('Network Error.');
      log(exception.toString());
    }
  }

  _requestError(text) {
    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(_appBarText),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Builder(
                    builder: (context) {
                      return AddItemDialog(widget.placeId, context);
                    }
                  )
                ));
            //_displayDialog(context);
          },
          label: Text('Item', style: TextStyle(color: Colors.black54)),
          splashColor: Colors.blue,
          elevation: 16,
          icon: Icon(Icons.add_circle, color: Colors.black),
          backgroundColor: Colors.amber,
        ),
        body: Container(
          child: Column(
            children: [
              SearchBox(),
              _itemBoxes.length > 0 ? Expanded(
                child: RefreshIndicator(
                  onRefresh: _getItems,
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(bottom: 80),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: _itemBoxes,
                        )
                      ),
              ),
                )) : Container(
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
  final int itemLocation;
  final BuildContext context;
  AddItemDialog(this.itemLocation, this.context);

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
  _submitForm() async {
    // validate at least 1 field is not empty
    bool isValid = false;

    // read items from text field and add it to a list
    List<String> itemNames = List<String>();
    controllers.forEach((element) {
      if (element.text
          .toString()
          .length > 0) {
        isValid = true;
        itemNames.add(element.text.toString());
      }
    });

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> jsonRaw = {
        "pid": widget.itemLocation,
        "user_hash": sharedPrefs.getString("hash1"),
        "items": itemNames
      };
    try {

      http.Response response = await http.post(
        Constants.apiURL + '/api/items/new',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonRaw),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == true) {
          setState(() {
            isLoading = false;
          });
         // widget.refresh();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, LocationViewPage.route + "/" + widget.itemLocation.toString()); //pop dialog

        } else {
         _requestError('Request Failed.');
        }
      }
      else {
        _requestError('Request Failed.');
      }
    } on SocketException catch(e) {
      _requestError('You are not connected to internet.');
      log(e.toString());
    }
    on TimeoutException catch(e) {
      _requestError('Server time out.');
      log(e.toString());
    }
    catch (exception) {
      _requestError('Network Error.');
      log(exception.toString());
    }
  }
  }

  _requestError(text) {
    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
    Scaffold.of(widget.context).hideCurrentSnackBar();
    Scaffold.of(widget.context).showSnackBar(snackBar);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? CustomLoadingDialog.widget : AlertDialog(
      elevation: 12,
      scrollable: true,
      //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      title: Text('Add Items', style: TextStyle(
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