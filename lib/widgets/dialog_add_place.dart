import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/Translations.dart';
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

    var t = Translations.of(context);
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
            await InventoryViewPage.refreshWidget();
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          }
          else {
            _snackBar(t.text("snack_msg_req_failed"));
          }
        }
        else {
          _snackBar(t.text("snack_msg_req_failed"));
        }
      } on SocketException catch(e) {
        _snackBar(t.text("snack_msg_no_connection"));
        log(e.toString());
      }
      on TimeoutException catch(e) {
        _snackBar(t.text("snack_msg_timeout"));
        log(e.toString());
      }
      catch (exception) {
        _snackBar(t.text("snack_msg_network_err"));
        log(exception.toString());
      }

    }
  }

  _snackBar(text) {
    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
    Scaffold.of(widget.context).hideCurrentSnackBar();
    Scaffold.of(widget.context).showSnackBar(snackBar);
    setState(() {
      isLoading = false;
    });
  }

  _dialogTextFieldDecoration() {
    var t = Translations.of(context);
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
      hintText: t.text("inventory_add_place_hint"),

    );
  }

  @override
  Widget build(BuildContext context) {
    var t = Translations.of(context);
    return isLoading ? CustomLoadingDialog.widget : AlertDialog(
      elevation: 12,
      scrollable: true,
      //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      title: Text(t.text("inventory_add_place_msg"), style: TextStyle(
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
            child: Text(t.text("cancel"), style: TextStyle(
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
          child: new Text(t.text("done")),
          color: Colors.blue,
          onPressed: () {
            _submitForm();
          },
        )
      ],
    );
  }
}
