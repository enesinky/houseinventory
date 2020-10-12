
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/start.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/huawei_account.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:huawei_account/auth/auth_huawei_id.dart';
import 'package:huawei_account/hms_account.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';


class AccountViewPage extends StatefulWidget {
  static const String route = '/Account';
  @override
  _AccountViewPageState createState() => _AccountViewPageState();
}

class _AccountViewPageState extends State<AccountViewPage> {

  var userInfo;
  var secureKey;
  String joinedDate;
  var isLoading ;
  bool huaweiUser;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  void dispose() {
    super.dispose();
    isLoading = true;
  }

  requestUserInfo() async {

    try {
      http.Response response = await http.post(
        Constants.apiURL + '/api/user',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token":  sharedPrefs.getString("token")
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var json = jsonDecode(response.body);
        json['result'] == true ?
        setState(() {
          userInfo = json;
          isLoading = false;
        }) :
        _promptError('Account Error', 'Something went wrong while gathering account information.', 'Try Again').then((value) => Navigator.of(context).pop());
      }
      else {
        _promptError('Server Error', 'Problem occured while communicating with server.', 'Try Again').then((value) => Navigator.of(context).pop());
      }
    } catch (exception) {
      _promptError('Network Error', 'Problem occured while communicating with server.', 'Try Again').then((value) => Navigator.of(context).pop());
    }
  }

  Future<void> _promptError(String title, String body, String buttonText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonText, style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _promptConfirmation(String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 0),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Signout', style: TextStyle(color: Colors.red),),
              onPressed: () {
                logoutProcedure();
              },
            )
          ],
        );
      },
    );
  }
  void logoutProcedure() {
    sharedPrefs.setString("token", null);
    sharedPrefs.setString("secure_key", null);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed(StartPage.route);
  }

  Widget accountRow(Widget label, Widget field) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black45,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
          // to make the coloured border
          ],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        direction: Axis.horizontal, // main axis (rows or columns)
        //mainAxisSize: MainAxisSize.max,
        children: [
          label,
          field
        ],
      ),
    );
  }

  var accountRowLabelTextStyle = TextStyle(fontSize: 14, color: Colors.black54, );
  var accountRowFieldTextStyle = TextStyle(fontSize: 14, color: Colors.black26, fontWeight: FontWeight.bold );

  @override
  Widget build(BuildContext context) {
    requestUserInfo();
    if (userInfo != null) {
      secureKey = userInfo['user']['secure_key'].toString().substring(0, 15) +
          '****************' +
          userInfo['user']['secure_key'].toString().substring(31, 39) +
          '****************' +
          userInfo['user']['secure_key'].toString().substring(55, userInfo['user']['secure_key'].toString().length);
      var formatter = new DateFormat('d MMMM, yyyy');
      joinedDate = formatter.format(DateTime.parse(userInfo['user']['created']));
    }


    return Scaffold(
        appBar: CustomAppBar('Account Info'),
        body: isLoading ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ) : Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
            Container(
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: (userInfo['user']['avatar'] == '') ? ExactAssetImage('assets/images/blank-profile-photo.png') : NetworkImage(userInfo['user']['avatar']),
                    )
                )),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userInfo['user']['hw_open_id'] == '' ? Container() : Image.asset('assets/images/btn_48x48_hw_singin_light_red.png', width: 32, height: 32,), SizedBox(width: 5,),
                  Text(userInfo['user']['name'].toString().toUpperCase(), textScaleFactor: 1.2, style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 20,),
              userInfo['user']['hw_open_id'] != '' ? Container() : accountRow(Text('Email:', style: accountRowLabelTextStyle,), userInfo['user']['hw_id_token'] == '' ? Text(userInfo['user']['email'].toString().toLowerCase(), style: accountRowFieldTextStyle,) : Text('(Signed With Huawei ID)', style: accountRowFieldTextStyle)),
              //accountRow(Text('Name:', style: accountRowLabelTextStyle,), Text(userInfo['user']['name'].toString().toUpperCase(), style: accountRowFieldTextStyle)),
              accountRow(Text('Encryption Key:', style: accountRowLabelTextStyle,), Text(secureKey, style: accountRowFieldTextStyle)),
              accountRow(Text('Joined Date:', style: accountRowLabelTextStyle,), Text(joinedDate, style: accountRowFieldTextStyle)),
              SizedBox(height: 40,),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.red.shade300, width: 2)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Out'.toUpperCase(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(width: 10,),
                    Icon(Icons.exit_to_app, size: 18, color: Colors.red)
                  ],
                ),
                color: Colors.grey.shade200,
                onPressed: () {
                  _promptConfirmation('Confirm Signout', 'Are you sure to signout?');
                },
              ),
            ],
          ),
        ));
  }


}


