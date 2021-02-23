import 'package:houseinventory/util/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingListItemBool extends StatefulWidget {
  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final bool defaultValue;

  SettingListItemBool(this.title, this.subtitle, this.sharedPrefParam, this.defaultValue);

  @override
  _SettingListItemBoolState createState() => _SettingListItemBoolState(this.title, this.subtitle, this.sharedPrefParam, this.defaultValue);

}

class _SettingListItemBoolState extends State<SettingListItemBool> {

  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final bool defaultValue;

  _SettingListItemBoolState(this.title, this.subtitle, this.sharedPrefParam, this.defaultValue);

  @override
  Widget build(BuildContext context) {
    // set default value initially
    if(sharedPrefs.getBool(sharedPrefParam) == null) sharedPrefs.setBool(sharedPrefParam, defaultValue);

    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
      value: sharedPrefs.getBool(sharedPrefParam),
      onChanged: (val) {
        setState(() {
          sharedPrefs.setBool(sharedPrefParam, val);
        });
      },
    ),
      onTap: () {
        setState(() {
          bool setting = !sharedPrefs.getBool(sharedPrefParam);
          sharedPrefs.setBool(sharedPrefParam, setting);
        });
      },
    );
  }
}


