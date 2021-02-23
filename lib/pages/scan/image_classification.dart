import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:houseinventory/model/location.dart';
import 'package:houseinventory/model/recognized_object.dart';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/widgets/dialog_add_place.dart';
import 'package:houseinventory/widgets/recognized_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:houseinventory/widgets/appbar.dart';
import 'package:huawei_ml/classification/ml_image_classification_client.dart';
import 'package:huawei_ml/classification/ml_image_classification_settings.dart';
import 'package:huawei_ml/classification/model/ml_image_classification.dart';
import 'package:huawei_ml/permissions/permission_client.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  static const route = "/Camera";
  static Function invokeBottomSheet;
  static Function refreshLocationList;

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcessing = false;
  bool isLoading = false;
  bool isFinished = false;
  bool showImagePickingOptions = false;

  MlImageClassificationSettings settings;
  List<Widget> addedObjectsWidgets = List<Widget>();
  List<Widget> recognizedObjectWidgets = List<Widget>();
  List<RecognizedObject> recognizedObjects = List<RecognizedObject>();

  String inventoryDropDownValue;
  String strInventoryName;
  List<Location> locationList = List<Location>();

  @override
  void initState() {
    settings = new MlImageClassificationSettings();
    _checkPermissions();
    super.initState();
    ScanPage.invokeBottomSheet = _showImagePickingOptions;
    ScanPage.refreshLocationList = _updateLocationList;
  }

  _updateLocationList() {
    setState(() {
      locationList.clear();
      InventoryViewPage.locations.forEach((element) {
        locationList.add(element);
      });
      locationList.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  _checkPermissions() async {
    if (await MlPermissionClient.checkCameraPermission()) {
      print("Permissions are granted");
    } else {
      await MlPermissionClient.requestCameraPermission();
    }
  }

  Future<String> getImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);
    return pickedFile.path;
  }

  _showSnackBar(message, color) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    return scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 12,
          content: Container(
            //height: 12.0,
              child: Text(message, style: TextStyle(color: Colors.white),)),
          backgroundColor: color,));
  }

  _requestAddItems() async {
    var selectedObjects = recognizedObjects.where((element) => element.isSelected == true);
    if (selectedObjects.length > 0 && inventoryDropDownValue != null) {
      setState(() {
        isLoading = true;
        isFinished = false;
      });
      List<String> objectList = List<String>();
      selectedObjects.forEach((element) {
        objectList.add(element.name);
      });

      var body = jsonEncode(<String, dynamic>{
        "pid": int.parse(inventoryDropDownValue),
        "user_hash": sharedPrefs.getString("hash1"),
        "items": selectedObjects.map((e) => e.name).toList()
      });

      try {
        http.Response response = await http.post(
          Constants.apiURL + '/api/items/new',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.body);
          setState(() {
            isLoading = false;
            isFinished = true;
          });
          if(json['result'] == true) {
            setState(() {
              addedObjectsWidgets.clear();
              selectedObjects.forEach((element) {
                addedObjectsWidgets.add(addedObjectWidget(element));
              });
              strInventoryName = locationList.where((element) => element.pid==int.parse(inventoryDropDownValue)).first.name;
              recognizedObjects.clear();
            });
            _showSnackBar("Items Added.", Colors.green);
            InventoryViewPage.refreshWidget();
            _showImagePickingOptions(toggle: true);
          } else {
            _showSnackBar("Something went wrong!", Colors.red);
          }
        }
        else {
          _showSnackBar("Server Error: Problem occured while communicating with server.", Colors.red);
        }
      } catch (exception) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar("Network Error: Problem occured while communicating with server.", Colors.red);
      }
    }
  }

  _startRecognition() async {
    settings.largestNumberOfReturns = 10;
    switch(sharedPrefs.getInt("recognitionPrecision")) {
      case 0:
        settings.minAcceptablePossibility = 0.9;
        break;
      case 1:
        settings.minAcceptablePossibility = 0.8;
        break;
      case 2:
        settings.minAcceptablePossibility = 0.7;
        break;
    }

    try {
      // show loading bar
      setState(() {
        isProcessing = true;
        isFinished = false;
        showImagePickingOptions = false;
      });
      // wait for result
      final List<MlImageClassification> classification =
      await MlImageClassificationClient.getRemoteClassificationResult(settings);
      if(classification.length > 0) {
        setState(() {
          recognizedObjectWidgets.clear();
          recognizedObjects.clear();
          classification.asMap().forEach((index, element) {
            var object = new RecognizedObject(
                element.name,
                element.possibility,
                element.possibility > 0.85 ? true : false);
            recognizedObjects.add(object);
            recognizedObjectWidgets.add(RecognizedItemWidget(object));
          });
        });
      }
      setState(() {
        isProcessing = false;
      });
    } on Exception catch (e) {
      print(e.toString());
      setState(() {
        isProcessing = false;
      });
    }
  }

  _showImagePickingOptions({bool toggle}) {
    setState(() {
      showImagePickingOptions = !toggle ? true : !showImagePickingOptions;
    });
  }


  Widget addedObjectWidget(RecognizedObject object) {
    return Container(
      child:
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done, size: 14, color: Colors.white),
          SizedBox(width: 4,),
          Text(object.name, style: TextStyle(
              color: Colors.white,
              fontSize: 16),),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12)
      ),
    );
  }

  var noObjectWidget = Center(
      child: Text('No object recognized yet.', style: TextStyle(
        fontSize: 13,
        color: Colors.black54,
        fontStyle: FontStyle.italic,
      ),),
  );

  var processingWidget = Container(
    margin: EdgeInsets.symmetric(vertical: 30),
    child: Center(
      child: Column(
        children: [
          CircularProgressIndicator(strokeWidth: 7, backgroundColor: Colors.black12,),
          SizedBox(height: 10,),
          Text("Processing", style: TextStyle(color: Colors.black12, fontSize:14))
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar("Scan Objects"),
          bottomSheet: showImagePickingOptions ? Container(
            height: 100,
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      child: RaisedButton(
                          padding: EdgeInsets.all(4),
                          color: Colors.amberAccent,
                          textColor: Colors.black,
                          child: Column(
                            children: [
                              Icon(Icons.add_a_photo),
                              Text("Take Photo", style: TextStyle(fontSize: 13),),
                            ],
                          ),
                          onPressed: () async {
                            final String path = await getImage(ImageSource.camera);
                            settings.path = path;
                            _startRecognition();
                          }),
                    ),
                    Container(
                      height: 50,
                      child: RaisedButton(
                          padding: EdgeInsets.all(4),
                          color: Colors.amberAccent,
                          textColor: Colors.black,
                          child: Column(
                            children: [
                              Icon(Icons.photo_library),
                              Text("Select From Gallery",
                                style: TextStyle(fontSize: 13),),
                            ],
                          ),
                          onPressed: () async {
                            final String path = await getImage(ImageSource.gallery);
                            settings.path = path;
                            _startRecognition();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ) : null,
          body: isLoading ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              processingWidget,
            ],
          ) : SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: isLoading,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: SizedBox(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImagePickingOptions(toggle: true);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 36),
                            child: Image.asset("assets/images/machine-learning.png", height: 100,)
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //   padding: EdgeInsets.all(10),
                        //   decoration: BoxDecoration(
                        //     color: Colors.amberAccent,
                        //     borderRadius: BorderRadius.circular(6)
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Wrap(
                        //         spacing: 8.0, // gap between adjacent chips
                        //         runSpacing: 4.0, // gap between lines
                        //         direction: Axis.horizontal,
                        //         children: [
                        //           Text("This feature will automatically list you possible suggestions after recognizing the objects on photo.",
                        //               style: TextStyle(color: Colors.black54, )),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        isFinished == true ? Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              children: [Text('Items Added to ', style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38
                              ),),
                              Text(strInventoryName, style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent
                              ),)],
                            )
                        ) : Container(),

                        isFinished == false && isLoading == false && recognizedObjects.length == 0 ? noObjectWidget : Container(),

                        recognizedObjects.length > 0 && isFinished == false ? Container(
                          //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Recognized Objects:", style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),

                            ],
                          ),
                        ) : Container(),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 24),
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 4.0, // gap between lines
                            direction: Axis.horizontal,
                            children: isProcessing ? [processingWidget] : (isFinished ? addedObjectsWidgets : recognizedObjectWidgets),
                          ),
                        ),

                        recognizedObjects.length > 0 && isFinished == false ? Column(
                          children: [
                            SizedBox(height: 36,),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: DropdownButton<String>(
                                icon: Icon(Icons.view_list),
                                isExpanded: true,
                                dropdownColor: Colors.amberAccent,
                                hint: Text('Select Place'),
                                //value: inventoryDropDownValue,
                                style: TextStyle(fontSize: 15, color: Colors.black,),
                                elevation: 16,
                                underline: Container(
                                  height: 0,
                                  color: Colors.black12,
                                ),
                                value: inventoryDropDownValue,
                                items: locationList.map((Location location) {
                                  return DropdownMenuItem<String>(
                                    value: location.pid.toString(),
                                    child: Text(location.name),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    inventoryDropDownValue = newValue;
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 36,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  //side: BorderSide(color: Colors.red)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text((locationList == null || locationList.length == 0) ? 'Create an Inventory' : 'Add to Inventory', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),),
                                  ],
                                ),
                                color: Colors.blueAccent,
                                onPressed: () {
                                  int selectedCount = recognizedObjects == null ? 0 : recognizedObjects.where((element) => element.isSelected).length;
                                  if (selectedCount == 0) {
                                    String str = "Select objects ";
                                    str += (locationList!=null && locationList.length>0 && inventoryDropDownValue==null) ? "and location ":"";
                                    str += "to add.";
                                    _showSnackBar(str, Colors.red);
                                  }
                                  else if(locationList == null || locationList.length == 0) {
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
                                  }
                                  else {
                                    _requestAddItems();
                                  }
                                },
                              ),
                            ),
                          ],
                        ) : Container(),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),

    );
  }

}


