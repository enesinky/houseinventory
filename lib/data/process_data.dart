import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/model/item_location.dart';
import 'package:houseinventory/widgets/location_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ProcessData {
  static List<ItemLocation> _itemsData;
  static List<Widget> _locationCards;
  static List<ItemLocation> get itemsData => _itemsData;
  static List<Widget> get locationDataCards => _locationCards;

  init() {

      // jsonData.forEach((element) {
      //   // initialize items list
      //   List<Item> items = List<Item>();
      //   add each item into itemLocation object
      //   element['items'].forEach((el) {
      //     items.add(Item(el['name'], el['id']));
      //   });
      //   // finally add itemLocation objects into itemLocation List
      //   ItemLocation itemLocation = ItemLocation(element['name'], element['id'], items);
      //   itemLocations.add(itemLocation);
      //   // add LocationCard widget into the list
      //   locationCards.add(LocationCard(element['name'], element['items'].length, element['id']));
      // });


      // if (itemLocations != null) {
      //   _itemsData = itemLocations;
      //   _locationCards = locationCards;
      // }
      // else {
      //   // protect from being crashed
      //   // if no card is created, return an empty widget
      //   _locationCards = [Container()];
      // }


  }




}

