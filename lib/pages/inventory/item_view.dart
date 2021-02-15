import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/widgets/appbar.dart';


class ItemViewPage extends StatefulWidget {
  static const String route = '/Item';
  final int itemId;
  ItemViewPage(this.itemId);

  @override
  _ItemViewPageState createState() => _ItemViewPageState();

}

class _ItemViewPageState extends State<ItemViewPage> {

  Item item;

  @override
  void initState() {
    super.initState();
    getItem();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getItem() async {
    try {
      http.Response response = await http.post(
        Constants.apiURL + '/api/items/get',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "iid": widget.itemId,
          "user_hash": sharedPrefs.getString("hash1")
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if(jsonData['result'] == true ){

          // setState(() {
          //   item = Item(jsonData['name'].toString(), jsonData['iid'], jsonData['placeName'].toString(),
          //       jsonData['created'].toString(), jsonData['modified'].toString());
          // });

        }
        else {
          // list failed
        }
      }
      else {

      }
    } catch (exception) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("item"),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Welcome to item + '),
              item != null ? Text("item name: " + item.name) : Text("waiting")
            ],
          ),
        ));
  }
}
