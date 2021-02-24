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
  _SettingListItemBoolState createState() => _SettingListItemBoolState();

}

class _SettingListItemBoolState extends State<SettingListItemBool> {


  @override
  Widget build(BuildContext context) {
    // set default value initially
    if(sharedPrefs.getBool(widget.sharedPrefParam) == null) sharedPrefs.setBool(widget.sharedPrefParam, widget.defaultValue);

    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: widget.subtitle != null ? Text(widget.subtitle) : null,
      trailing: Switch(
      value: sharedPrefs.getBool(widget.sharedPrefParam),
      onChanged: (val) {
        setState(() {
          sharedPrefs.setBool(widget.sharedPrefParam, val);
        });
      },
    ),
      onTap: () {
        setState(() {
          bool setting = !sharedPrefs.getBool(widget.sharedPrefParam);
          sharedPrefs.setBool(widget.sharedPrefParam, setting);
        });
      },
    );
  }
}


