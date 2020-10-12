class Constants {

  static var _apiURL = "http://192.168.1.39:9888/houseinventory_backend";

  static int _API_TIME_OUT_LIMIT = 5;

  static var _MAX_ADD_ITEM_LIMIT = 10;

  //static var _apiURL = "http://10.0.2.2:9888/houseinventory_backend";

  static get apiURL => _apiURL;

  static get MAX_ADD_ITEM_LIMIT => _MAX_ADD_ITEM_LIMIT;

  static get API_TIME_OUT_LIMIT => _API_TIME_OUT_LIMIT;
}