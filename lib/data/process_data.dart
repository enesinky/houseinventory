import 'dart:convert';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/model/item_location.dart';
import 'package:houseinventory/ui/cards/location_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ProcessData {
  static List<ItemLocation> _itemsData;
  static List<Widget> _locationCards;

  init() async {
    if (_itemsData == null) {
      // initialize widget list
      List<Widget> locationCards = List<Widget>();

      // initialize itemLocations list
      List<ItemLocation> itemLocations = List<ItemLocation>();

      // load data from json file
      String data = await rootBundle.loadString('assets/json/item_data.json');
      List<dynamic> jsonData = jsonDecode(data);

      // loop each data
      // example data: (1 ItemLocation , 2 items)
      // [
      //   {
      //     "name": "Bedroom",
      //     "id": 1,
      //     "items": [
      //       {
      //         "name": "Bed",
      //         "id": 19
      //       },
      //       {
      //         "name": "Wardrobe",
      //         "id": 20
      //       }
      //     ]
      //   }
      // ]
      //
      jsonData.forEach((element) {
        // initialize items list
        List<Item> items = List<Item>();
        // add each item into itemLocation object
        element['items'].forEach((el) {
          items.add(Item(el['name'], el['id']));
        });
        // finally add itemLocation objects into itemLocation List
        ItemLocation itemLocation = ItemLocation(element['name'], element['id'], items);
        itemLocations.add(itemLocation);
        // add LocationCard widget into the list
        locationCards.add(LocationCard(element['name'], element['items'].length, element['id']));
      });


      if (itemLocations != null) {
        _itemsData = itemLocations;
        _locationCards = locationCards;
      }
      else {
        // protect from being crashed
        // if no card is created, return an empty widget
        _locationCards = [Container()];
      }


    }
  }

  static List<ItemLocation> get locationData => _itemsData;

  static List<Widget> get locationDataCards => _locationCards;
}
final processData = ProcessData();
