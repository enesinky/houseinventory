import 'package:covid19_mask/ui/setting_list_item.dart';

import 'ui/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TO-DO:
//


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => SettingsPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Settings'),
        body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child:
          ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SettingGroupLabel('General Settings'),
          SettingListItemBool('Enable Push Notifications', null, 'push_notifications', true),
          SettingListItemBool('Test Setting #1', 'This is a test setting', 'test_1', true),
          SettingListItemBool('Test Setting #2', 'This is a test setting', 'test_2', true),
                SettingGroupLabel('Dashboard Settings'),
          SettingListItemSelect('Language', 'Select the language of application', 'test_select', ['English', 'Turkish', 'German'], 2),
          SettingListItemBool('Test Setting #4', 'This is a test setting', 'test_4', false),
          SettingListItemBool('Test Setting #5', 'This is a test setting', 'test_5', true)
          ]),),
        ])
    )
    );
  }

}