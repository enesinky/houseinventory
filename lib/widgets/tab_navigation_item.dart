import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/search/search.dart';
import '../../pages/dashboard/dashboard.dart';
import '../../pages/settings/settings.dart';
import '../../pages/inventory/location_view.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: Dashboard(),
      icon: Icon(Icons.dashboard),
      title: Text("Dashboard"),
    ),
    TabNavigationItem(
      page: InventoryPage(),
      icon: Icon(Icons.view_list),
      title: Text("Inventory List"),
    ),
    TabNavigationItem(
      page: SearchPage(),
      icon: Icon(Icons.search),
      title: Text("Search"),
    ),
    TabNavigationItem(
      page: SettingsPage(),
      icon: Icon(Icons.settings),
      title: Text("Settings"),
    ),
  ];
}