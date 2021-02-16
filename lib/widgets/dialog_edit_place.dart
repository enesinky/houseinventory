import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:houseinventory/model/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading_dialog.dart';
import 'package:http/http.dart' as http;


class EditPlaceDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Location location;

  const EditPlaceDialog({this.scaffoldKey, this.location});


  @override
  _EditPlaceDialogState createState() => _EditPlaceDialogState();
}

class _EditPlaceDialogState extends State<EditPlaceDialog> {

  bool isLoading;
  bool toggleDeletePage;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController textEditingControllerDelete = new TextEditingController();


  @override
  void initState() {
    super.initState();
    isLoading = false;
    toggleDeletePage = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _snackBar({Color color, String text}) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    widget.scaffoldKey.currentState.hideCurrentSnackBar();
    widget.scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _deleteRequest() async {
      try {
        http.Response response = await http.post(
          Constants.apiURL + '/api/places/delete',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "pid": widget.location.pid,
            "user_hash": sharedPrefs.getString("hash1")
          }),
        ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
        if (response != null && response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if(jsonData['result'] == true) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
            InventoryViewPage.refreshWidget();
            _snackBar(color: Colors.green, text: widget.location.name + " deleted from inventory.");
          }
          else {
            _snackBar(color: Colors.red, text: "Request Failed.");
          }
        }
        else {
          _snackBar(color: Colors.red, text: "Request Failed.");
        }
      } on SocketException catch(e) {
        _snackBar(color: Colors.red, text: "You are not connected to internet.");
      }
      on TimeoutException catch(e) {
        _snackBar(color: Colors.red, text: "Server timed out.");
      }
      catch (exception) {
        _snackBar(color: Colors.red, text: "Network Error.");
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
        borderSide: BorderSide(color: toggleDeletePage ? Colors.red : Colors.amber, width: 2),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      hintText: !toggleDeletePage ? "Place name" : "",

    );
  }

  @override
  Widget build(BuildContext context) {

    textEditingController.text = widget.location.name;
    DateTime dateCreated = DateTime.parse(widget.location.created);
    DateTime dateModified = DateTime.parse(widget.location.modified);
    final currentTime = new DateTime.now();
    var createdTa = timeago.format(
        currentTime.subtract(Duration(milliseconds: currentTime.millisecondsSinceEpoch - dateCreated.millisecondsSinceEpoch)),
        locale: 'en');
    var modifiedTa = timeago.format(
        currentTime.subtract(Duration(milliseconds: currentTime.millisecondsSinceEpoch - dateModified.millisecondsSinceEpoch)),
        locale: 'en');

    return isLoading ? CustomLoadingDialog.widget : AlertDialog(
      elevation: 12,
      scrollable: true,
      //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      title: Text(toggleDeletePage ? 'Delete Place' : 'Modify Place', style: TextStyle(
        fontSize: 16,
      )),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      actionsPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      content: toggleDeletePage ? Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type "yes" in order to proceed.', style: TextStyle(fontSize: 14, color: Colors.black54),),
            SizedBox(height: 12,),
            TextField(
              maxLines: 1,
              maxLength: 30,
              autofocus: false,
              autocorrect: false,
              controller: textEditingControllerDelete,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 14),
              decoration: _dialogTextFieldDecoration(),
            ),
            SizedBox(height: 12,),
            widget.location.itemCount > 0 ?
            Text('Deleting '+widget.location.name+' will also delete all items (' + widget.location.itemCount.toString() + ') belong to it.',
              style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),) :
            Container(),
          ],
        ),
      ) :
      Container(
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
            SizedBox(height: 12,),
            Text('You modified this place ' + createdTa + ".", style: TextStyle(fontSize: 11, color: Colors.black54),)
          ],
        ),
      ),
      actions: toggleDeletePage ?
      <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              toggleDeletePage = false;
            });
          },
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
          child: new Text('DELETE'),
          color: Colors.red,
          onPressed: () {
            if(textEditingControllerDelete.text == "yes") {
              setState(() {
                toggleDeletePage = false;
                isLoading = true;
              });
              _deleteRequest();
            }
          },
        )
      ] : <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    toggleDeletePage = true;
                  });
                },
                borderRadius: BorderRadius.all(Radius.circular(16)),
                splashColor: Colors.amber,
                highlightColor: Colors.amber,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),

                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outlined, size: 22, color: Colors.red),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                splashColor: Colors.amber,
                child: Container(
                  width: 56,
                  height: 30,
                  alignment: Alignment.center,
                  padding:
                  EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
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

                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
