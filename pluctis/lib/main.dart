import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/models/vegetables_list.dart';
import 'package:pluctis/pages/intro_page.dart';
import 'package:pluctis/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Enable in app purchase
  InAppPurchaseConnection.enablePendingPurchases();

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationSettings()),
        ChangeNotifierProvider(create: (context) => PlantsList()),
        ChangeNotifierProvider(create: (context) => VegetablesList(),)
      ],
      child: Consumer<ApplicationSettings>(
        builder: (context, applicationStyle, child) {
          return MaterialApp(
            title: 'Pluctis',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: applicationStyle.brightness,
              
              scaffoldBackgroundColor: applicationStyle.scaffoldColor,
              cardColor: applicationStyle.cardColor,
              primaryColor: applicationStyle.primaryColor,
              accentColor: applicationStyle.accentColor,

              cardTheme: CardTheme(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: applicationStyle.cardColor,
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8)
              ),

              appBarTheme: AppBarTheme(
                color: applicationStyle.scaffoldColor,
                elevation: 0,
              ),

              textTheme: TextTheme(
                headline6: TextStyle(fontSize: 38.0, fontWeight: FontWeight.w500, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                subtitle2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                subtitle1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white),
                caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: applicationStyle.brightness == Brightness.light ? Colors.black87 : Colors.white)
              ),
            ),
            home: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final SharedPreferences preferences = snapshot.data as SharedPreferences;

                  final bool introduced = preferences.getBool("introduced") ?? false;

                  if (introduced) {
                    return MainPage();
                  }

                  return IntroPage();
                }

                return Container(
                  color: Theme.of(context).accentColor,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/spring.svg',
                      semanticsLabel: "Icon",
                      width: 96, height: 96,
                    ),
                  ),
                );
              }
            )
          );
        }
      )
    );
  }
}