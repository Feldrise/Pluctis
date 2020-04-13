import 'package:flutter/material.dart';
import 'package:pluctis/Models/ApplicationStyle.dart';
import 'package:pluctis/Pages/DashboardPage.dart';
import 'package:pluctis/Pages/MainPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new ApplicationStyle())
      ],
      child: Consumer<ApplicationStyle>(
        builder: (context, applicationStyle, child) {
          return MaterialApp(
            title: 'Pluctis',
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
                margin: EdgeInsets.all(8)
              ),

              appBarTheme: AppBarTheme(
                color: applicationStyle.scaffoldColor,
                elevation: 0,
              )
            ),
            home: MainPage()
          );
        }
      )
    );
  }
}