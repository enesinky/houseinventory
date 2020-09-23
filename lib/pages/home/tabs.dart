import '../../widgets/tab_navigation_item.dart';
import 'package:flutter/material.dart';


class TabsPage extends StatefulWidget {
  static const String route = '/';
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 14.0,
        fixedColor: Colors.black,
        backgroundColor: Colors.amber,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        iconSize: 32,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        //selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              //backgroundColor: Colors.amber,
              icon: tabItem.icon,
              title: tabItem.title,
            )
        ],
      ),
    );
  }
}