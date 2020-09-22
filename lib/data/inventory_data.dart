import 'dart:convert';

import 'package:covid19_mask/model/object.dart';
import 'package:flutter/services.dart';

class Inventory {

  Future<List<ObjectLocation>> getLocations() async {
    String data = await rootBundle.loadString('lib/data/locations.json');
    var jsonResult = json.decode(data) as List;
    List<ObjectLocation> locationResult = jsonResult.map((locJson) => ObjectLocation.fromJson(locJson)).toList();
    //print(jsonResult);
    List<ObjectLocation> locations = List<ObjectLocation>();
    locationResult.forEach((element) {
      locations.add(ObjectLocation(element.name, element.id));
    });
    return locations;
  }


}
