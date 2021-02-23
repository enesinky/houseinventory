import 'package:houseinventory/pages/dashboard/dashboard.dart';
import 'package:houseinventory/pages/scan/image_classification.dart';
import '../../widgets/tab_navigation_item.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  static const String route = DashBoard.route;
  static BuildContext context;

  @override
  _TabsPageState createState() => _TabsPageState();

}

class _TabsPageState extends State<TabsPage> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    TabsPage.context = context;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        fixedColor: Colors.black,
        backgroundColor: Colors.amber,
        currentIndex: currentIndex,
        onTap: (int index) {
          if(index == 2) {
            ScanPage.invokeBottomSheet(toggle: currentIndex == index);
          }
            setState(() {
              currentIndex = index;
            });

        },
        iconSize: 32,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 36,
                child: tabItem.icon,
              ),
              label: tabItem.title + "\n",
            )
        ],
      ),
    );
  }
}