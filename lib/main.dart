import 'package:houseinventory/pages/start/start.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/login_handler.dart';
import 'package:houseinventory/util/route_configuration.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'application.dart';
import 'pages/home/tabs.dart';
import 'util/shared_prefs.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  bool isLoggedIn = await loginHandler.init();
  runApp(
    MyApp(isLoggedIn),
  );

}

class MyApp extends StatefulWidget {

  final bool isLoggedIn;
  MyApp(this.isLoggedIn);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState(){
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    applic.onLocaleChanged = onLocaleChange;

    if(sharedPrefs.getString(applic.languageSharedPref) == null) {
      var deviceLanguageCode = Localizations.localeOf(context).languageCode;
      var languageCode = applic.supportedLanguages.contains(deviceLanguageCode) ? deviceLanguageCode : 'en';
      sharedPrefs.getString(languageCode);
      onLocaleChange(Locale(languageCode, ''));
    }
    else {
      onLocaleChange(Locale(sharedPrefs.getString(applic.languageSharedPref), ''));
    }
  }

  onLocaleChange(Locale locale){
    setState((){
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {

    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return MaterialApp(
      title: 'House Inventory',
      supportedLocales: applic.supportedLocales(),
      localizationsDelegates: [
        _localeOverrideDelegate,
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffECE9CA),
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: widget.isLoggedIn ? TabsPage.route : StartPage.route,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }


}
