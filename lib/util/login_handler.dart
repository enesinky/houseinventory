import 'dart:convert';

import 'package:houseinventory/util/shared_prefs.dart';
import 'package:http/http.dart' as http;

import 'contants.dart';
class LoginHandler {
  init() async {
    final http.Response response = await http.post(
        Constants.apiURL + '/api/token',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token":  sharedPrefs.getString("token")
        }),
      ).timeout(
          const Duration(seconds: 5), onTimeout: () {
        return null;
      });
    print("login handler, status code=" + (response.statusCode).toString());
    return (response.statusCode == 200);
  }
}
final loginHandler = LoginHandler();