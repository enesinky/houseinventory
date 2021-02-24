import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/util/shared_prefs.dart';

class SettingListItemDropdown extends StatefulWidget {
  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final List<String> options;
  final int defaultValue;

  SettingListItemDropdown(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);
  @override
  _SettingListItemDropdownState createState() => _SettingListItemDropdownState();

}

class _SettingListItemDropdownState extends State<SettingListItemDropdown> {

  @override
  Widget build(BuildContext context) {
    // set sharedprefs default value initially
    if(sharedPrefs.getInt(widget.sharedPrefParam) == null) sharedPrefs.setInt(widget.sharedPrefParam, widget.defaultValue);

    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: widget.subtitle != null ? Text(widget.subtitle) : null,
      trailing: widget.options.first != '' ? DropdownButton<String>(
        value: sharedPrefs.getInt(widget.sharedPrefParam).toString(),
        style: TextStyle(fontSize: 14, color: Colors.black),
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.amber,
        ),
        items: widget.options.map((String value) {
          return DropdownMenuItem<String>(
            value: widget.options.indexOf(value).toString(),
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            sharedPrefs.setInt(widget.sharedPrefParam, int.parse(newValue));
          });
        },
      ): SizedBox(width: 20,),
    );
  }
}