import 'dart:async';
import 'dart:convert';
import 'package:houseinventory/model/location.dart';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import '../../widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  static const String route = '/Dashboard';
  static Function reload;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  bool emptyFlag;
  String emptyStr;
  List<Location> locations;
  List<InventoryUtilizationData> utilizationData = List<InventoryUtilizationData>();
  List<ItemAddPerformanceData> newlyAddedGraphData = List<ItemAddPerformanceData>();


  String _convertDateString(int i) {
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[i-1];
  }

  _reload() {
    locations = InventoryViewPage.locations;
    emptyFlag = locations.length == 0 || locations.where((location) => location.itemCount > 0).length == 0;

    setState(() {
      utilizationData.clear();

      if(!emptyFlag) {
        // Push inventory locations which has at least 1 item
        locations.forEach((e) {
          if (e.itemCount > 0) {
            utilizationData.add(InventoryUtilizationData(e.name, e.itemCount.toDouble()));
          }
        });

        _getItemCountByCreatedDate();

      }
      else {
        utilizationData.add(InventoryUtilizationData(Translations.of(context).text("dashboard_empty"), 1));
      }

    });
  }

  Future<void> _getItemCountByCreatedDate() async {
    try {
      setState(() {
        newlyAddedGraphData.clear();
      });
      http.Response response = await http
          .post(
        Constants.apiURL + '/api/items/dashboard-items',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_hash": sharedPrefs.getString("hash1")
        }),
      )
          .timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == true) {
          List<dynamic> objects = jsonData['objects'];
          setState(() {
            objects.forEach((element) {
              String period = _convertDateString(element['month']) + " " + element['year'].toString().substring(2);
              if(objects.length == 1) {
                newlyAddedGraphData.add(
                    ItemAddPerformanceData(period, 0)
                );
              }
              newlyAddedGraphData.add(
                ItemAddPerformanceData(period, element['itemCount'].toDouble())
              );
            });
          });
        }
      }
    }
    catch (exception) {

    }
  }

  encryptionDialog (BuildContext ctx) {
    var t = Translations.of(ctx);
    return AlertDialog(
      title: Text(t.text("dashboard_encryption")),
      content: Text(t.text("dashboard_encryption_msg")),
      actions: [
        FlatButton(
          child: Text(t.text("ok"), style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold),),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DashBoard.reload = _reload;
    var t = Translations.of(context);

    return Scaffold(
        appBar: CustomAppBar(t.text("appbar_dashboard")),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 400,
                        alignment: Alignment.topCenter,
                        child: SfCircularChart(
                            title: ChartTitle(
                                text: t.text("dashboard_util"),
                                // Aligns the chart title to left
                                alignment: ChartAlignment.near,
                                // ignore: deprecated_member_use
                                textStyle: ChartTextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )
                            ),
                            legend: Legend(
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.wrap,
                                position: LegendPosition.bottom),
                            series: <CircularSeries>[
                              DoughnutSeries<InventoryUtilizationData, String>(
                                  dataSource: utilizationData,
                                  //enableSmartLabels: true,
                                  xValueMapper: (InventoryUtilizationData data, _) => data.locationName,
                                  yValueMapper: (InventoryUtilizationData data, _) => data.itemCount,
                                  explode: true,
                                  // Explode all the segments
                                  explodeAll: true,
                                  dataLabelMapper: (InventoryUtilizationData data, int i) => (emptyFlag ? "" : data.locationName + " (" + data.itemCount.toInt().toString() + ")"),
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      // Positioning the data label
                                      //labelPosition: ChartDataLabelPosition.inside,
                                      //useSeriesColor: true
                                  )
                              )
                            ]
                        )
                    )
                ),
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 400,
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Enable legend
                           // legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            title: ChartTitle(
                                text: t.text("dashboard_perf"),
                                // Aligns the chart title to left
                                alignment: ChartAlignment.near,
                                // ignore: deprecated_member_use
                                textStyle: ChartTextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                            ),
                            series: <LineSeries<ItemAddPerformanceData, String>>[
                              LineSeries<ItemAddPerformanceData, String>(
                                // Bind data source
                                  dataSource: newlyAddedGraphData,
                                  xValueMapper: (ItemAddPerformanceData data, _) => data.period,
                                  yValueMapper: (ItemAddPerformanceData data, _) => data.itemCount,
                                  //dataLabelSettings: DataLabelSettings(isVisible: true)
                              )
                            ]
                        )
                    )
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  //margin: EdgeInsets.symmetric(ho),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: Colors.black38, size:20),
                          Text(t.text("dashboard_encryption"), style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,),),
                          SizedBox(width: 20,),
                          InkWell(
                            splashColor: Colors.amber,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return encryptionDialog(context);
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(t.text("dashboard_learn_how"), style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold),),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50,)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
    
  }
}

class InventoryUtilizationData {
  InventoryUtilizationData(this.locationName, this.itemCount, [this.color]);
  final String locationName;
  final double itemCount;
  final Color color;
}

class ItemAddPerformanceData {
  ItemAddPerformanceData(this.period, this.itemCount);
  final String period;
  final double itemCount;
}