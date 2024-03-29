import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:houseinventory/model/item.dart';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/widgets/dialog_add_item.dart';
import 'package:houseinventory/widgets/sort_box.dart';
import '../../application.dart';
import '../../widgets/appbar.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/widgets/item_card.dart';

class LocationViewPage extends StatefulWidget {
  static const String route = '/Location';
  final int placeId;

  LocationViewPage(this.placeId);

  @override
  _LocationViewPageState createState() => _LocationViewPageState();
}

class _LocationViewPageState extends State<LocationViewPage> {
  List<Widget> currentItemBoxes = List<Widget>();
  List<ItemBox> loadedItemBoxes = List<ItemBox>();

  bool isLoading;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cardSelectionMode = false;
  String locationName = "";
  String appBarText = "";

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getItems() async {
    var t = Translations.of(APPLIC.mainContext);
    try {
      http.Response response = await http
          .post(
            Constants.apiURL + '/api/items/list',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "by": "modified",
              "pid": widget.placeId,
              "order": "DESC",
              "user_hash": sharedPrefs.getString("hash1")
            }),
          )
          .timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == true) {
          List<dynamic> items = jsonData['items'];
          loadedItemBoxes.clear();
          if(items.length > 0) {
            for (var i = 0; i < items.length; i++) {
              var item = items[i];
              var itemObject = Item(item['name'].toString(), item['iid'],
                  item['placeName'], item['created'], item['modified'], false);

              loadedItemBoxes.add(new ItemBox(
                item: itemObject,
                isSelected: itemObject.isCardSelected,
                onLongPress: (iid) {
                  _onLongPress(iid);
                },
                onTap: (iid) {
                  _onTap(iid);
                },
              ));
              if (i == items.length - 1) {
                setState(() {
                  sortItems(sharedPrefs.getInt("itemsSortBy"), sharedPrefs.getInt("itemsOrderBy"));
                  locationName = item['placeName'];
                  appBarText = item['placeName'];
                  isLoading = false;
                });
              }
            }
          } else {
            setState(() {
              currentItemBoxes.clear();
              isLoading = false;
            });
          }
        } else {
          _showSnackBar(t.text("snack_msg_req_failed"));
        }
      } else {
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

  Future<void> _deleteItems() async {
    var t = Translations.of(APPLIC.mainContext);
    try {
      setState(() {
        isLoading = true;
      });
      List<int> iids = List<int>();
      loadedItemBoxes.where((element) => element.isSelected).forEach((el) {
        iids.add(el.item.iid);
      });
      http.Response response = await http
          .post(
        Constants.apiURL + '/api/items/delete',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "iid": iids,
          "user_hash": sharedPrefs.getString("hash1")
        }),
      )
          .timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == true) {
          setState(() {
            cardSelectionMode = false;
            InventoryViewPage.refreshWidget();
            _getItems();
          });
          _deletionSuccess(t.text("snack_msg_items_deleted", {
            "count": iids.length,
            "item": (iids.length > 1 ? t.text("items_plural") : t.text("items_singular"))
          }));

        } else {
          _showSnackBar(t.text("snack_msg_req_failed"));
        }
      } else {
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

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
    setState(() {
      isLoading = false;
    });
  }

  _deletionSuccess(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  sortItems(int sort, int order) {

    switch(sort) {
      case 0:
        loadedItemBoxes.sort(
                (a, b) => order == 0 ?
                a.item.name.toLowerCase().compareTo(b.item.name.toLowerCase()) :
                b.item.name.toLowerCase().compareTo(a.item.name.toLowerCase())
        );
        break;
      case 1:
        loadedItemBoxes.sort(
                (a, b) => order == 0 ?
                DateTime.parse(a.item.modified).compareTo(DateTime.parse(b.item.modified)) :
                DateTime.parse(b.item.modified).compareTo(DateTime.parse(a.item.modified))
        );
        break;
      case 2:
        loadedItemBoxes.sort(
                (a, b) => order == 0 ?
                DateTime.parse(a.item.created).compareTo(DateTime.parse(b.item.created)) :
                DateTime.parse(b.item.created).compareTo(DateTime.parse(a.item.created))
        );
        break;
    }

    setState(() {
      currentItemBoxes.clear();
      loadedItemBoxes.forEach((element) {
        currentItemBoxes.add(element);
      });
    });

  }

  _onTap(int iid) {
    if(cardSelectionMode) {
      _toggleCard(iid);
      var selectCount = loadedItemBoxes.where((element) => element.isSelected == true).length;
      if(selectCount == 0) {
        setState(() {
          cardSelectionMode = false;
        });
      }
    }

  }

  _onLongPress(int iid) {
    if(!cardSelectionMode) {
      setState(() {
        cardSelectionMode = true;
      });
      _toggleCard(iid);
    }
  }

  _toggleCard(int iid) {
    setState(() {
      var box = loadedItemBoxes.where((element) => element.item.iid == iid).first;
      box.isSelected = !box.isSelected;
      box.refresh();
    });
  }

  confirmDeletionDialog (BuildContext ctx) {
    var t = Translations.of(ctx);
    var c = loadedItemBoxes
        .where((element) => element.isSelected == true)
        .length;
    return AlertDialog(
      title: Text(t.text("items_delete_label")),
      content: Text(t.text("items_delete_msg", {"count": c})),
      actions: [
        FlatButton(
          child: Text(
          t.text("cancel"), style: TextStyle(color: Colors.blue,),),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
        FlatButton(
          child: Text(t.text("delete"), style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold),),
          onPressed: () {
            Navigator.of(ctx).pop();
            _deleteItems();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = Translations.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(appBarText),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Builder(builder: (context) {
                      return AddItemDialog(widget.placeId, context);
                    })));
          },
          label: Text(t.text("item_singular"), style: TextStyle(color: Colors.black54)),
          splashColor: Colors.blue,
          elevation: 16,
          icon: Icon(Icons.add_circle, color: Colors.black),
          backgroundColor: Colors.amber,
        ),
        body: isLoading ?
        Center(
          child: Container(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 7, backgroundColor: Colors.black12)
          ),
        )
            : Center(
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width * 0.90,
            margin: EdgeInsets.symmetric(vertical: 8),
            //margin: EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: cardSelectionMode ? Row(
                        children: [
                          InkWell(
                            splashColor: Colors.amber,
                            highlightColor: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return confirmDeletionDialog(context);
                                  });
                            },
                            child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Icon(Icons.delete, size: 20, color: Colors.red,),
                          ))
                        ],
                      ):Container(),
                    ),
                    currentItemBoxes.length > 0 ? AbsorbPointer(
                      absorbing: (currentItemBoxes.length <= 1),
                      child: SortBox(
                        onSortChange: (int sort, int order) {
                          sortItems(sort, order);
                        },
                        sortingOptions: [t.text("sort_alpha"), t.text("sort_date_modified"), t.text("sort_date_created")],
                        orderingOptions: [
                          [t.text("order_a_to_z"), t.text("order_z_to_a")],
                          [t.text("order_oldest_first"), t.text("order_newest_first")],
                          [t.text("order_oldest_first"), t.text("order_newest_first")]
                        ],
                        sortMethodSharedPref: "itemsSortBy",
                        orderMethodSharedPref: "itemsOrderBy",
                      ),
                    ) : Container()
                  ],
                ),
                currentItemBoxes.length > 0
                    ? Expanded(
                        child: RefreshIndicator(
                        onRefresh: _getItems,
                        child: SingleChildScrollView(
                          physics: currentItemBoxes.length > 1 ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                              child: Wrap(
                            direction: Axis.horizontal,
                            children: currentItemBoxes,
                          )),
                        ),
                      ))
                    : Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mood_bad_rounded, size: 36, color: Colors.amber),
                              Text(
                                t.text("items_empty_msg"),
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                    ),
              ],
            ),
          ),
        ));
  }
}

