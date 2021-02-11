import 'dart:convert';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'contants.dart';

class LoginHandler {
  Future<bool> init() async {
    if(sharedPrefs.getString("hash1") != null && sharedPrefs.getString("hash2") != null ){
      try {
        final http.Response response = await http.post(
          Constants.apiURL + '/api/auth',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email":  sharedPrefs.getString("hash1"),
            "password":  sharedPrefs.getString("hash2")
          }),
        ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
        var statusCode = response.statusCode;
        var json = jsonDecode(response.body);
        return (statusCode == 200 && json['result'] == true);
      } catch (exception) {
        return false;
      }
    }
    else {
      return false;
    }

  }
}
final loginHandler = LoginHandler();