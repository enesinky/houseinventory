
import 'package:houseinventory/widgets/setting_list_item.dart';

import '../../widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const String route = '/Settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.black26,
                height: 36,
                thickness: 0.7,
              )),
        ),
        Text("About", style: TextStyle(color: Colors.black26, fontSize: 14, fontWeight: FontWeight.bold),),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.black26,
                height: 36,
                thickness: 0.7,
              )),
        ),
      ]),
    );

    return Scaffold(
        appBar: CustomAppBar('Settings'),
        body: SingleChildScrollView(
          child: SizedBox(
              child: Container(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SettingGroupLabel('General Settings'),
                      SettingListItemBool('List Newer Items First',
                          'Order items from newest to oldest.', 'test_1', true),
                      SettingListItemBool('Colorize Items Randomly',
                          'Item colors will change each time.', 'randomItemColor', true),
                      SettingGroupLabel('Language Settings'),
                      SettingListItemSelect(
                          'System Language',
                          'Select the language of application',
                          'test_select',
                          ['English', 'Turkish', 'German'],
                          2),
                      SettingGroupLabel('Machine Learning Settings'),
                      SettingListItemSelect(
                          'Recognition Precision',
                          'Object recognition sensitivity.',
                          'test_select',
                          ['High', 'Medium', 'Low'],
                          1),
                      SettingListItemBool(
                          'Translate Object Names', 'Default language is English.', 'test_4', true),
                      SettingListItemBool(
                          'Test Setting #5', 'This is a test setting', 'test_3', true),
                      Container(
                        // margin: EdgeInsets.sypmmetric(horizontal: 20, vertical: 10),
                        child: Column(
                        children: [
                          divider,
                          Text("Developed by Enes Inkaya"),
                          Text("enesinkaya@gmail.com", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                          SizedBox(height: 40,),
                        ],
                      ))
          ]),
              )),
        ));
  }
}
