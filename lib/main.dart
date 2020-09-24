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
      initialRoute: TabsPage.route,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      //initialRoute: '/',
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/': (context) => TabsPage(),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   InventoryPage.route: (context) => InventoryPage(),
      //   Dashboard.route: (context) => Dashboard(),
      //   SettingsPage.route: (context) => SettingsPage(),
      //   SearchPage.route: (context) => SearchPage()
      //
      // },

    );
  }
}