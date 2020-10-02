import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }
  bool getBool(String sharedPrefParam) {
    return _sharedPrefs.getBool(sharedPrefParam);
  }
  void setBool(String sharedPrefParam, bool value) {
      _sharedPrefs.setBool(sharedPrefParam, value);
  }

  int getInt(String sharedPrefParam) {
    return _sharedPrefs.getInt(sharedPrefParam);
  }
  void setInt(String sharedPrefParam, int value) {
    _sharedPrefs.setInt(sharedPrefParam, value);
  }

  String getString(String sharedPrefParam) {
    return _sharedPrefs.getString(sharedPrefParam);
  }
  void setString(String sharedPrefParam, String value) {
    _sharedPrefs.setString(sharedPrefParam, value);
  }
}

final sharedPrefs = SharedPrefs();