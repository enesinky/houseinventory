import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/shared_prefs.dart';

import '../application.dart';

class SettingListItemLanguage extends StatefulWidget {

  @override
  _SettingListItemLanguageState createState() => _SettingListItemLanguageState();

}

class _SettingListItemLanguageState extends State<SettingListItemLanguage> {


  @override
  Widget build(BuildContext context) {

    String language = sharedPrefs.getString(applic.languageSharedPref);

    var t = Translations.of(context);

    return ListTile(
      title: Text(
        t.text("setting_language"),
        style: TextStyle(fontSize: 14),
      ),
      subtitle: null,
      trailing: DropdownButton<String>(
        value: language,
        style: TextStyle(fontSize: 14, color: Colors.black),
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.amber,
        ),
        items: applic.supportedLanguages.map((String languageCode) {
          return DropdownMenuItem<String>(
            value: languageCode,
            child: Text(Translations.of(context).text('languageName_'+languageCode)));
        }).toList(),
        onChanged: (String newValue) {
          if(language != newValue) {
            setState(() {
              applic.onLocaleChanged(new Locale(newValue,''));
              sharedPrefs.setString(applic.languageSharedPref, newValue);
            });
          }
        },
      ),
    );
  }
}