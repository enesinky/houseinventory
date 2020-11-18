import 'dart:convert';
import 'package:houseinventory/model/recognized_object.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:houseinventory/widgets/appbar.dart';
import 'package:huawei_ml/classification/ml_image_classification_client.dart';
import 'package:huawei_ml/classification/ml_image_classification_settings.dart';
import 'package:huawei_ml/classification/model/ml_image_classification.dart';
import 'package:huawei_ml/permissions/permission_client.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  static const route = "/Camera";

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;
  bool isProcessing = false;
  bool isLoading = false;
  bool isFinished = false;
  MlImageClassificationSettings settings;
  List<Widget> objectWidgets = List<Widget>();
  List<RecognizedObject> recognizedObjects = List<RecognizedObject>();
  var inventoryDropDownValue;

  @override
  void initState() {
    settings = new MlImageClassificationSettings();
    _checkPermissions();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showImagePickingOptions());
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
              child: Text(message, style: TextStyle(fontSize: 12, color: Colors.white),)),
          backgroundColor: color,));
  }
  _addItemCompletedProcedure() {
    _showSnackBar("Items Added.", Colors.green);
    setState(() {
      isFinished = true;
    });
    _showImagePickingOptions();
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
        "token": sharedPrefs.getString("token"),
        "inventory": inventoryDropDownValue,
        "items": objectList
      });

      try {
        http.Response response = await http.post(
          Constants.apiURL + '/api/items/new',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
        setState(() {
          isLoading = false;
        });

        if (response != null && response.statusCode == 200) {
          var json = jsonDecode(response.body);
          json['result'] == true ? _addItemCompletedProcedure() : _showSnackBar("Something went wrong!", Colors.red);
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
    }else {
      _showSnackBar("Select objects and inventory place.", Colors.black);
    }
  }
  _startRecognition() async {
    settings.largestNumberOfReturns = 10;
    settings.minAcceptablePossibility = 0.5;
    try {
      // clear recognized objects
      recognizedObjects.clear();
      // show loading bar
      setState(() {
        isProcessing = true;
        isFinished = false;
      });
      // wait for result
      final List<MlImageClassification> classification =
      await MlImageClassificationClient.getRemoteClassificationResult(settings);
      classification.asMap().forEach((index, element) {
        setState(() {
          recognizedObjects.add(new RecognizedObject(
              element.name,
              element.possibility,
              element.possibility > 0.7 ? true : false));
        });
      });
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
  _showImagePickingOptions() async {
    scaffoldKey.currentState.showBottomSheet((context) =>
        Container(
          height: 150,
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: Colors.amber,
          child: Row(
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
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                      _startRecognition();
                    }),
              ),
            ],
          ),
        ));
  }
  Widget recognizedObjectWidget(int index, RecognizedObject object) {
    double possibilityAmplified = object.possibility * 10;
    double opacityFactor = (index == 0 || index == 1) ? 1.0 : possibilityAmplified.roundToDouble() / 10;
    Color color = Colors.blueAccent.withOpacity(opacityFactor);

    return InkWell(
      child: Container(
        child: Text(object.name, style: TextStyle(
            color: object.isSelected ? Colors.white : Colors.black.withOpacity(0.25),
            fontSize: 16),),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        decoration: BoxDecoration(
            color: object.isSelected ? color : Colors.black26,
            borderRadius: BorderRadius.circular(12)
        ),
      ),
      onTap: ()  {
        setState(() {
          object.isSelected = !object.isSelected;
        });
      },
    );
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
          color: Colors.green,
          borderRadius: BorderRadius.circular(12)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

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
      objectWidgets.clear();
      if(recognizedObjects.length > 0 && !isFinished) {
        recognizedObjects.asMap().forEach((index, element) {
          objectWidgets.add(recognizedObjectWidget(index, element));
        });
      }
      else if(recognizedObjects.length == 0 && !isFinished) {
        objectWidgets.add(noObjectWidget);
      }
      else if(isFinished) {
        recognizedObjects.where((element) => element.isSelected == true).forEach((element) {
          objectWidgets.add(addedObjectWidget(element));
        });
      }
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar("Object Recognition"),
          body: isLoading ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              processingWidget,
            ],
          ) : SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: isLoading,
              child: SizedBox(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showImagePickingOptions();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Image.asset("assets/images/machine-learning.png", height: 100,)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 4.0, // gap between lines
                            direction: Axis.horizontal,
                            children: [
                              Text("This feature will automatically list you possible suggestions after recognizing the objects on photo.",
                                  style: TextStyle(color: Colors.white70, )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isFinished == true ? Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Wrap(
                          children: [Text('Items Added to ', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38
                          ),),
                          Text(inventoryDropDownValue, style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),)],
                        )
                    ) : Container(),
                    recognizedObjects.length > 0 && isFinished == false ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Text("Recognized Objects:", style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                    ) : Container(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        direction: Axis.horizontal,
                        children: isProcessing ? [processingWidget] : objectWidgets,
                      ),
                    ),
                    recognizedObjects.length > 0 && isFinished == false ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                            value: inventoryDropDownValue,
                            style: TextStyle(fontSize: 15, color: Colors.black,),
                            elevation: 16,
                            underline: Container(
                              height: 0,
                              color: Colors.black12,
                            ),
                            // items: options.map((String value) {
                            //   return DropdownMenuItem<String>(
                            //     value: value,
                            //     child: Text(value),
                            //   );
                            // }).toList(),
                            items: [
                              DropdownMenuItem(value: 'Bedroom', child: Text('Bedroom')),
                            DropdownMenuItem(value: 'Basement', child: Text('Basement')),
                              DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
                                DropdownMenuItem(value: 'Small Room Sofa', child: Text('Small Room Sofa')),
                                  DropdownMenuItem(value: 'My Super Room', child: Text('My Super Room'))
                              ],
                            onChanged: (String newValue) {
                              setState(() {
                                inventoryDropDownValue = newValue;
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 36,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Add to Inventory', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),
                              ],
                            ),
                            color: Colors.blueAccent,
                            onPressed: () {
                              _requestAddItems();
                            },
                          ),
                        ),
                      ],
                    ) : Container(),


                  ],
                ),
              ),
            ),
          )),

    );
  }

}


