import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:huawei_account/auth/auth_huawei_id.dart';
import 'package:huawei_account/helpers/auth_param_helper.dart';
import 'package:huawei_account/hms_account.dart';
import 'package:http/http.dart' as http;

import 'contants.dart';

class HuaweiAccount {
  BuildContext ctx;
  HuaweiAccount(this.ctx);

  signIn() async {
    AuthParamHelper helper = new AuthParamHelper();
    helper..setProfile()..setIdToken()..setRequestCode(8888);
    try {
     final AuthHuaweiId authHuaweiId = await HmsAccount.signIn(helper);
      requestSignIn(authHuaweiId);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getResult() async {
    final AuthHuaweiId authHuaweiId = await HmsAccount.getAuthResult();
    return authHuaweiId;
  }

  Future<void> _promptError(String title, String body, String buttonText) async {
    return showDialog<void>(
      context: this.ctx,
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

  void loginProcedure(json) {
    sharedPrefs.setString("token", json['token']);
    sharedPrefs.setString("secure_key", json['secure_key']);
    Navigator.of(this.ctx).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(this.ctx, TabsPage.route);
  }

  requestSignIn(AuthHuaweiId authHuaweiId) async {
    try {
      http.Response response = await http.post(
        Constants.apiURL + '/api/huawei_account',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "hw_id_token":  authHuaweiId.idToken,
          "hw_open_id": authHuaweiId.openId,
          "name": authHuaweiId.givenName + ' ' + authHuaweiId.familyName,
          "avatar": authHuaweiId.avatarUriString
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if(response != null && response.statusCode == 200) {
        var json = jsonDecode(response.body);
       (json['result'] == true && json['token'] != null) ? loginProcedure(json) : null;
      }
      else {
        _promptError('Server Error', 'Problem occured while communicating with server.', 'Try Again');
      }
    } catch (exception) {
      _promptError('Network Error', 'Problem occured while communicating with server.', 'Try Again');
    }
  }

}