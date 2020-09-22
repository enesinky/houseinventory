import 'dart:convert';
import 'package:houseinventory/model/object.dart';
import 'package:houseinventory/ui/cards/location_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LocationData {
  static List<ObjectLocation> _locationData;
  static List<Widget> _locationDataCards;

  init() async {
    if (_locationData == null) {
      String data = await rootBundle.loadString('assets/json/locations.json');
      var jsonResult = json.decode(data) as List;
      List<ObjectLocation> locationResult = jsonResult.map((locJson) =>
          ObjectLocation.fromJson(locJson)).toList();
      //print(locationResult);
      _locationData = locationResult;

      // handle widgets
      List<Widget> locationCards = List<Widget>();
      locationResult.forEach((element) {
       locationCards.add(LocationCard(element.name, 12, element.id));
      });

      _locationDataCards = locationCards;

    }
  }

  static List<ObjectLocation> get locationData => _locationData;

  static List<Widget> get locationDataCards => _locationDataCards;
}
final locationData = LocationData();
