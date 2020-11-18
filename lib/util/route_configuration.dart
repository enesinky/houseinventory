import 'package:houseinventory/pages/account/account_view.dart';
import 'package:houseinventory/pages/camera/image_classification.dart';
import 'package:houseinventory/pages/dashboard/dashboard.dart';
import 'package:houseinventory/pages/inventory/inventory_view.dart';
import 'package:houseinventory/pages/inventory/item_view.dart';
import 'package:houseinventory/pages/inventory/location_view.dart';
import 'package:houseinventory/pages/search/search.dart';
import 'package:houseinventory/pages/settings/settings.dart';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/forgot_password.dart';
import 'package:houseinventory/pages/start/start.dart';

import 'path.dart';

class RouteConfiguration {

  static List<Path> paths = [
    Path(
      r'^\/Location\/([\0-9]+)$',
          (context, List matches) => LocationViewPage(int.parse(matches[0])),
    ),
    Path(
      r'^\/Item\/([0-9]+)\/([0-9]+)$',
          (context, List matches) => ItemViewPage(int.parse(matches[0]), int.parse(matches[1])),
    ),
    Path(
      r'^' + StartPage.route,
          (context, match) => StartPage(),
    ),
    Path(
      r'^' + ForgotPasswordPage.route,
          (context, match) => ForgotPasswordPage(),
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
      r'^' + InventoryViewPage.route,
          (context, match) => InventoryViewPage(),
    ),
    Path(
      r'^' + SearchPage.route,
          (context, match) => SearchPage(),
    ),
    Path(
      r'^' + SettingsPage.route,
          (context, match) => SettingsPage(),
    ),
    Path(
      r'^' + AccountViewPage.route,
          (context, match) => AccountViewPage(),
    ),
    Path(
      r'^' + CameraPage.route,
          (context, match) => CameraPage(),
    ),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (Path path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        Iterable matchInstances = regExpPattern.allMatches(settings.name);
        List<String> matches = List<String>();
        matchInstances.forEach((match) {
              for(var i=1; i <= match.groupCount; i++) {
                matches.add(match.group(i).toString());
              }
        });
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, matches),
          settings: settings,
        );
      }
    }
    return null;
  }
}