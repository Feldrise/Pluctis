import 'package:flutter/material.dart';

class ApplicationStyle with ChangeNotifier {

  var _brightness = Brightness.light;

  var _lightScaffoldColor = Color(0xffffffff);
  var _darkScaffoldColor = Color(0xff23272F);

  var _lightPrimaryColor = Color(0xffffffff);
  var _darkPrimaryColor = Color(0xff2C313B);

  var _lightCardColor = Color(0xffffffff);
  var _darkCardColor = Color(0xff2C313B);

  var _accentColor = Color(0xff8e24aa);

  Brightness get brightness => _brightness;
  set brightness (Brightness newBrightness) {
    _brightness = newBrightness;
    notifyListeners();
  }

  Color get scaffoldColor => brightness == Brightness.light ? _lightScaffoldColor : _darkScaffoldColor;
  Color get primaryColor => brightness == Brightness.light ? _lightPrimaryColor : _darkPrimaryColor;
  Color get cardColor => brightness == Brightness.light ? _lightCardColor : _darkCardColor;
  Color get accentColor => _accentColor;

  set accentColor(Color newColor) {
    _accentColor = newColor;
    notifyListeners();
  }
}