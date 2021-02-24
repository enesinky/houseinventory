import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/application.dart';
import 'package:houseinventory/model/location.dart';
import 'package:houseinventory/pages/dashboard/dashboard.dart';
import 'package:houseinventory/pages/scan/image_classification.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/widgets/dialog_add_place.dart';
import 'package:houseinventory/widgets/dialog_edit_place.dart';
import 'package:houseinventory/widgets/location_card.dart';
import 'package:houseinventory/widgets/sort_box.dart';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/contants.dart';
import '../../widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class InventoryViewPage extends StatefulWidget {
    static const String route = '/Inventory';
    static Function refreshWidget;
    static List<Location> locations = List<Location>();

    @override
    _InventoryViewPageState createState() => _InventoryViewPageState();
  }

class _InventoryViewPageState extends State<InventoryViewPage> {

  bool isLoading;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // invisible objects for checking update
  List<Location> currentLocationsObjects = List<Location>();
  List<Location> loadedLocationsObjects = List<Location>();

  // visible objects for sorting cards
  List<LocationCard> loadedLocationCards = List<LocationCard>();
  List<Widget> currentLocationCards = List<Widget>();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getPlaces();
    InventoryViewPage.refreshWidget = _getPlaces;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getPlaces() async {
    var t = Translations.of(APPLIC.mainContext);
    try {
      http.Response response = await http.post(
        Constants.apiURL + '/api/places/list',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "by": "created",
          "order": "DESC",
          "user_hash": sharedPrefs.getString("hash1")
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
      if(jsonData['result'] == true ){
        List<dynamic> places = jsonData['places'];
        loadedLocationsObjects.clear();
        loadedLocationCards.clear();
          for(var i = 0; i < places.length; i++) {
            var place = places[i];
            Location loc = Location(place['pid'], place['name'].toString(), place['itemCount'], place['created'], place['modified']);
            LocationCard card = LocationCard(
                location: loc,
                onLongPress: (int i) {
                  _editLocation(i);
                }
            );
            loadedLocationsObjects.add(loc);
            loadedLocationCards.add(card);
            if(i == places.length-1) {
              sortLocations(sharedPrefs.getInt("placesSortBy"), sharedPrefs.getInt("placesOrderBy"));
              DashBoard.reload();
              ScanPage.refreshLocationList();
            }
          }
          if(places.length == 0) {
            setState(() {
              isLoading = false;
              loadedLocationsObjects.clear();
              InventoryViewPage.locations.clear();
              currentLocationCards.clear();
            });
            DashBoard.reload();
            ScanPage.refreshLocationList();
          }
      }
        else {
          _showSnackBar(t.text("snack_msg_req_failed"));
        }
      }
      else {
        _showSnackBar(t.text("snack_msg_req_failed"));
      }
    } on SocketException catch(e) {
      _showSnackBar(t.text("snack_msg_no_connection"));
      log(e.toString());
    }
    on TimeoutException catch(e) {
      _showSnackBar(t.text("snack_msg_timeout"));
      log(e.toString());
    }
    catch (exception) {
      _showSnackBar(t.text("snack_msg_network_err"));
      log(exception.toString());
    }
  }

  _showSnackBar(text) {
    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
    setState(() {
      isLoading = false;
    });
  }

  sortLocations(int sort, int order) {

    switch(sort) {
      case 0:
        loadedLocationCards.sort(
                (a, b) => order == 0 ?
            a.location.name.toLowerCase().compareTo(b.location.name.toLowerCase()) :
            b.location.name.toLowerCase().compareTo(a.location.name.toLowerCase())
        );
        break;
      case 1:
        loadedLocationCards.sort(
                (a, b) => order == 0 ?
                b.location.itemCount.compareTo(a.location.itemCount) :
                a.location.itemCount.compareTo(b.location.itemCount)
        );
        break;
      case 2:
        loadedLocationCards.sort(
                (a, b) => order == 0 ?
            DateTime.parse(a.location.modified).compareTo(DateTime.parse(b.location.modified)) :
            DateTime.parse(b.location.modified).compareTo(DateTime.parse(a.location.modified))
        );
        break;
      case 3:
        loadedLocationCards.sort(
                (a, b) => order == 0 ?
            DateTime.parse(a.location.created).compareTo(DateTime.parse(b.location.created)) :
            DateTime.parse(b.location.created).compareTo(DateTime.parse(a.location.created))
        );
        break;
    }

    setState(() {
      isLoading = false;
      InventoryViewPage.locations = loadedLocationsObjects;
      currentLocationCards.clear();
      loadedLocationCards.forEach((element) {
        currentLocationCards.add(element);
      });
    });


  }

  _editLocation(int pid) {
    Location location = loadedLocationsObjects.where((element) => element.pid == pid).first;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
                builder: (context) {
                  return EditPlaceDialog(
                    scaffoldKey: _scaffoldKey,
                    location: location,
                  );
                }
            )
        ));
  }

  @override
    Widget build(BuildContext context) {
    var t = Translations.of(context);
      return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(t.text("appbar_inventory")),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Builder(
                          builder: (context) {
                            return AddPlaceDialog(context);
                          }
                      )
                  ));
            },
            //label: Text('Place'),
            mini: true,
            splashColor: Colors.blue,
            elevation: 1,
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.blueGrey,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: isLoading ?
          Center(
            child: Container(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 7, backgroundColor: Colors.black12)
            ),
          ) : Center(
            child: Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.90,
              margin: EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      currentLocationCards.length > 1 ? SortBox(
                        onSortChange: (int sort, int order) {
                          sortLocations(sort, order);
                        },
                        sortingOptions: [t.text("sort_alpha"), t.text("sort_item_count"), t.text("sort_date_modified"), t.text("sort_date_created")],
                        orderingOptions: [
                          [t.text("order_a_to_z"), t.text("order_z_to_a")],
                          [t.text("order_most"), t.text("order_least")],
                          [t.text("order_oldest_first"), t.text("order_newest_first")],
                          [t.text("order_oldest_first"), t.text("order_newest_first")]
                        ],
                        sortMethodSharedPref: "placesSortBy",
                        orderMethodSharedPref: "placesOrderBy",
                      ) : Container()
                    ],
                  ),
                  currentLocationCards.length > 0 ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: _getPlaces,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Container(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: currentLocationCards,
                                )
                            ),
                          ),
                        ),
                      )) : Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.view_list, size: 28, color: Colors.amber),
                          Text(
                            t.text("inventory_empty_msg"),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    }

  }






