import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading_dialog.dart';

class AddPlaceDialog extends StatefulWidget {
  final BuildContext context;
  AddPlaceDialog(this.context);

  @override
  _AddPlaceDialogState createState() => _AddPlaceDialogState();
}

class _AddPlaceDialogState extends State<AddPlaceDialog> {

  bool isLoading = false;

  TextEditingController textEditingController = new TextEditingController();

  _submitForm() async {

    if (textEditingController.text.toString().length >= 3) {
      setState(() {
        isLoading = true;
      });

      try {
        http.Response response = await http.post(
          Constants.apiURL + '/api/places/new',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "name": textEditingController.text.toString(),
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
          }
          else {
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
