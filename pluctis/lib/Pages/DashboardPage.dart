import 'package:flutter/material.dart';
import 'package:pluctis/Models/ApplicationStyle.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 96),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            child: Text("Change Brightness"),
            onPressed: () {
              // applicationStyle.brightness == Brightness.dark ? applicationStyle.brightness = Brightness.light : applicationStyle.brightness = Brightness.dark;
              if (Provider.of<ApplicationStyle>(context, listen: false).brightness == Brightness.dark) {
                Provider.of<ApplicationStyle>(context, listen: false).brightness = Brightness.light;
              } 
              else {
                Provider.of<ApplicationStyle>(context, listen: false).brightness = Brightness.dark;
              }
            },
          ),
        ),
      ),
    );
  }
}