import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  static const String route = '/Dashboard';

  // static Route<dynamic> route() => MaterialPageRoute(
  //   builder: (context) => Dashboard(),
  // );


  @override
  Widget build(BuildContext context) {

    final List<ChartData> chartData = [
      ChartData('Kitchen', 25),
      ChartData('Bedroom', 38),
      ChartData('Basement', 34),
      ChartData('Others', 52)
    ];

    final List<SalesData> chartDataSales = [
      SalesData(2010, 35),
      SalesData(2011, 28),
      SalesData(2012, 34),
      SalesData(2013, 32),
      SalesData(2014, 40)
    ];
    
    return Scaffold(
        appBar: CustomAppBar("Dashboard"),
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
                                text: 'Item Utilization',
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
                              DoughnutSeries<ChartData, String>(
                                  dataSource: chartData,
                                  //enableSmartLabels: true,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  explode: true,
                                  // Explode all the segments
                                  explodeAll: true,
                                  dataLabelMapper: (ChartData data, _) => data.x,
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
                            title: ChartTitle(
                                text: 'Recorded Items by Year',
                                // Aligns the chart title to left
                                alignment: ChartAlignment.near,
                                // ignore: deprecated_member_use
                                textStyle: ChartTextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                            ),
                            series: <ChartSeries>[
                              SplineSeries<SalesData, double>(
                                  dataSource: chartDataSales,
                                  // Type of spline
                                  splineType: SplineType.cardinal,
                                  cardinalSplineTension: 0.9,
                                  xValueMapper: (SalesData sales, _) => sales.year,
                                  yValueMapper: (SalesData sales, _) => sales.sales
                              )
                            ]
                        )
                    )
                )
              ],
            ),
          ),
        )
    );
    
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}