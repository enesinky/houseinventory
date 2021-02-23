import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:houseinventory/pages/scan/image_classification.dart';
import 'package:houseinventory/util/Translations.dart';

import '../pages/search/search.dart';
import '../pages/dashboard/dashboard.dart';
import '../pages/settings/settings.dart';
import '../pages/inventory/inventory_view.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final dynamic icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items {
    var t = Translations.of(TabsPage.context);
    return [
      TabNavigationItem(
        page: DashBoard(),
        icon: Icon(Icons.dashboard),
        title: t.text('tab_dashboard'),
      ),
      TabNavigationItem(
        page: InventoryViewPage(),
        icon: Icon(Icons.view_list),
        title: t.text('tab_inventory'),
      ),
      TabNavigationItem(
        page: ScanPage(),
        icon: Image.asset("assets/images/scan_64x64.png", height: 28, width: 28),
        title: t.text('tab_scan'),
      ),
      TabNavigationItem(
        page: SearchPage(),
        icon: Icon(Icons.search),
        title: t.text('tab_search'),
      ),
      TabNavigationItem(
        page: SettingsPage(),
        icon: Icon(Icons.settings),
        title: t.text('tab_settings'),
      ),
    ];
  }
}