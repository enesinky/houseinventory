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
  _SettingListItemDropdownState createState() => _SettingListItemDropdownState(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);

}

class _SettingListItemDropdownState extends State<SettingListItemDropdown> {

  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final List<String> options;
  final int defaultValue;

  _SettingListItemDropdownState(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);

  @override
  Widget build(BuildContext context) {
    // set sharedprefs default value initially
    if(sharedPrefs.getInt(sharedPrefParam) == null) sharedPrefs.setInt(sharedPrefParam, defaultValue);
    // set selectbox default value
    String dropDownValue = options[sharedPrefs.getInt(sharedPrefParam)];
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: DropdownButton<String>(
        hint: Text('Language'),
        value: dropDownValue,
        style: TextStyle(fontSize: 14, color: Colors.black),
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.amber,
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            dropDownValue = newValue;
            sharedPrefs.setInt(sharedPrefParam, options.indexOf(newValue));
          });
        },
      ),
    );
  }
}