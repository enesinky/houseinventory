import 'dart:convert';

import 'package:houseinventory/util/shared_prefs.dart';
import 'package:http/http.dart' as http;

import 'contants.dart';
class LoginHandler {
  Future<bool> init() async {
      try {
        final http.Response response = await http.post(
            Constants.apiURL + '/api/token',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "token":  sharedPrefs.getString("token")
            }),
          ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
        return (response.statusCode == 200);
      } catch (exception) {
        return false;
      }
  }
}
final loginHandler = LoginHandler();