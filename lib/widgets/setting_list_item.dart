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

class SettingListItemSelect extends StatefulWidget {
  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final List<String> options;
  final int defaultValue;

  SettingListItemSelect(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);
  @override
  _SettingListItemSelectState createState() => _SettingListItemSelectState(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);

}

class _SettingListItemSelectState extends State<SettingListItemSelect> {

  final String title;
  final String subtitle;
  final String sharedPrefParam;
  final List<String> options;
  final int defaultValue;

  _SettingListItemSelectState(this.title, this.subtitle, this.sharedPrefParam, this.options, this.defaultValue);

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

class SettingGroupLabel extends StatelessWidget {
  final String label;

  SettingGroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 15, 0, 0),
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(label, style:
        TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),)],
      ),
    );
  }
}

