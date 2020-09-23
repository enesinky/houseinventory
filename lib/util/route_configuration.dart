import 'package:houseinventory/pages/dashboard/dashboard.dart';
import 'package:houseinventory/pages/inventory/location_view.dart';
import 'package:houseinventory/pages/inventory/item_view.dart';
import 'package:houseinventory/pages/search/search.dart';
import 'package:houseinventory/pages/settings/settings.dart';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'path.dart';

class RouteConfiguration {

  static List<Path> paths = [
    Path(
      r'^/Location/([0-9]+)$',
          (context, match) => ItemViewPage(int.parse(match)),
    ),
    Path(
      r'^' + TabsPage.route,
          (context, match) => TabsPage(),
    ),
    Path(
      r'^' + Dashboard.route,
          (context, match) => Dashboard(),
    ),
    Path(
      r'^' + LocationViewPage.route,
          (context, match) => LocationViewPage(),
    ),
    Path(
      r'^' + SearchPage.route,
          (context, match) => SearchPage(),
    ),
    Path(
      r'^' + SettingsPage.route,
          (context, match) => SettingsPage(),
    ),

  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (Path path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        final firstMatch = regExpPattern.firstMatch(settings.name);
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match),
          settings: settings,
        );
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }
}