import 'package:houseinventory/pages/start/start.dart';
import 'package:houseinventory/util/route_configuration.dart';

import 'data/process_data.dart';
import 'pages/home/tabs.dart';
import 'util/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  await processData.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {

  var user;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      title: 'House Inventory',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffECE9CA),
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: TabsPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: user == null ? StartPage.route : TabsPage.route,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}