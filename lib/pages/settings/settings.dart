
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/widgets/setting_group_label.dart';
import 'package:houseinventory/widgets/setting_list_item_bool.dart';
import 'package:houseinventory/widgets/setting_list_item_dropdown.dart';
import 'package:houseinventory/widgets/setting_list_item_language.dart';
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
    var t = Translations.of(context);
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
        Text(t.text("settings_about"), style: TextStyle(color: Colors.black26, fontSize: 14, fontWeight: FontWeight.bold),),
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
        appBar: CustomAppBar(t.text("appbar_settings")),
        body: SingleChildScrollView(
          child: SizedBox(
              child: Container(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SettingGroupLabel(t.text("setting_general")),
                      SettingListItemBool(t.text("setting_color"),
                          t.text("setting_color_sub"), 'randomItemColor', true),
                      SettingListItemLanguage(),
                      SettingGroupLabel(t.text("settings_ml")),
                      SettingListItemDropdown(
                          t.text("setting_recognition_precision"),
                          t.text("setting_recognition_precision_sub"),
                          'recognitionPrecision',
                          [t.text("setting_high"), t.text("setting_med"), t.text("setting_low")],
                          1),
                      SettingListItemBool(
                          t.text("setting_translate_names"), t.text("setting_translate_names_sub", {"default": t.text("languageName_en")}), 'mlTranslate', true),
                      Container(
                        // margin: EdgeInsets.sypmmetric(horizontal: 20, vertical: 10),
                        child: Column(
                        children: [
                          divider,
                          Text(t.text("setting_about_develop_msg", {"developer": "Enes Inkaya"})),
                          Text("enesinkaya@gmail.com", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
                          SizedBox(height: 40,),
                        ],
                      ))
          ]),
              )),
        ));
  }
}
