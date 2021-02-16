import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/model/location.dart';
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
    InventoryViewPage.refreshWidget = _refreshPlaces;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getPlaces() async {
    print("getting places");
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
            }
          }
          if(places.length == 0) {
            setState(() {
              currentLocationCards.clear();
            });
          }
      }
        else {
          _requestError('Request Failed.');
        }
      }
      else {
        _requestError('Request Failed.');
      }
    } on SocketException catch(e) {
      _requestError('You are not connected to internet.');
      log(e.toString());
    }
    on TimeoutException catch(e) {
      _requestError('Server time out.');
      log(e.toString());
    }
    catch (exception) {
      _requestError('Network Error.');
      log(exception.toString());
    }
  }

  bool hasLocationUpdated(List<Location> var1, List<Location> var2) {
    bool result = false;
    if(var1.isNotEmpty) {
      var2.forEach((loc2) {
        bool isUpdated = var1.where((loc1) => loc2.pid == loc1.pid && loc2.name == loc1.name && loc2.itemCount == loc1.itemCount).isEmpty;
        print(isUpdated.toString());
        if(isUpdated) result = true;
      });
    }
    else {
      result = true;
    }

    return result;
  }

  _requestError(text) {
    final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshPlaces() async {
      _getPlaces();
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
      return Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar('Inventory List'),
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
                        sortingOptions: ['Alphabetically', 'Item Count', 'Date Modified','Date Created'],
                        orderingOptions: [
                          ["A to Z", "Z to A"],
                          ["Most to Least", "Least to Most"],
                          ["Oldest Items First", "Newest Items First"],
                          ["Oldest Items First", "Newest Items First"]
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
                            'Add a location your inventory.',
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






