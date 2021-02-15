import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/model/location.dart';
import 'package:houseinventory/widgets/loading_dialog.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/widgets/location_card.dart';
import 'package:houseinventory/widgets/sort_box.dart';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/contants.dart';
import '../../widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class InventoryViewPage extends StatefulWidget {
    static const String route = '/Inventory';

    @override
    _InventoryViewPageState createState() => _InventoryViewPageState();
  }

class _InventoryViewPageState extends State<InventoryViewPage> {

  var isLoading ;

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
  }


  @override
  void dispose() {
    super.dispose();
    isLoading = true;
  }

  refresh() {
    setState(() {

    });
  }

  getPlaces() async {
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
            loadedLocationsObjects.add(loc);
            loadedLocationCards.add(new LocationCard(loc));
            if(i == places.length-1 && hasLocationUpdated(currentLocationsObjects, loadedLocationsObjects)) {
              setState(() {
                currentLocationsObjects = loadedLocationsObjects;
                sortLocations(sharedPrefs.getInt("placesSortBy"), sharedPrefs.getInt("placesOrderBy"));
              });
            }
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
  }

  Future<void> _refreshPlaces() async {
      getPlaces();
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
      currentLocationCards.clear();
      loadedLocationCards.forEach((element) {
        currentLocationCards.add(element);
      });
    });

  }

  @override
    Widget build(BuildContext context) {
    getPlaces();
      return Scaffold(
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
                            return AddPlaceDialog(context, refresh);
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
          body: Center(
            child: Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                children: [
                  currentLocationCards.length > 1 ? SortBox(
                      onSortChange: (int sort, int order) {
                        setState(() {
                          sortLocations(sort, order);
                        });
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
                  ) : Container(),
                  currentLocationCards.length > 0 ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshPlaces,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(top: 16, bottom: 80),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: currentLocationCards,
                                )
                            ),
                          ),
                        ),
                      )) : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30),
                    child: Text('Add a location in your inventory.', style: TextStyle(fontSize: 17),),
                  ),
                ],
              ),
            ),
          )
      );
    }


  }


  class AddPlaceDialog extends StatefulWidget {
    final BuildContext context;
    final Function f;
    AddPlaceDialog(this.context, this.f);

    @override
    _AddPlaceDialogState createState() => _AddPlaceDialogState();
  }

  class _AddPlaceDialogState extends State<AddPlaceDialog> {

    bool isLoading = false;

    TextEditingController textEditingController = new TextEditingController();

    _submitForm() async {

      if (textEditingController.text.toString().length >= 3) {
        setState(() {
          isLoading = true;
        });

        try {
          http.Response response = await http.post(
            Constants.apiURL + '/api/places/new',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "name": textEditingController.text.toString(),
              "user_hash": sharedPrefs.getString("hash1")
            }),
          ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
          if (response != null && response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            if(jsonData['result'] == true) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
              widget.f();
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
    }

    _requestError(text) {
      final snackBar = SnackBar(content: Text(text, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red, duration: Duration(seconds: 2),);
      Scaffold.of(widget.context).hideCurrentSnackBar();
      Scaffold.of(widget.context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    }

    _dialogTextFieldDecoration() {
      return InputDecoration(
        enabled: true,
        //isDense: true,
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        hintText: "Place name",

      );
    }

    @override
    Widget build(BuildContext context) {

      return isLoading ? CustomLoadingDialog.widget : AlertDialog(
              elevation: 12,
              scrollable: true,
              //contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              title: Text('Add New Place to Inventory ', style: TextStyle(
                fontSize: 16,
              )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              actionsPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: [
                    TextField(
                      maxLines: 1,
                      maxLength: 30,
                      autofocus: true,
                      autocorrect: true,
                      controller: textEditingController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 14),
                      decoration: _dialogTextFieldDecoration(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.amber,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    child: Text('Cancel', style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //side: BorderSide(color: Colors.red)
                  ),
                  child: new Text('Done'),
                  color: Colors.blue,
                  onPressed: () {
                    _submitForm();
                  },
                )
              ],
            );
    }
  }





