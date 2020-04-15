import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationStyle with ChangeNotifier {
  var _initialized = false;

  var _brightness = Brightness.light;

  var _lightScaffoldColor = Color(0xffffffff);
  var _darkScaffoldColor = Color(0xff23272F);

  var _lightPrimaryColor = Color(0xffffffff);
  var _darkPrimaryColor = Color(0xff2C313B);

  var _lightCardColor = Color(0xffffffff);
  var _darkCardColor = Color(0xff2C313B);

  var _accentColor = Color(0xff8e24aa);

  void initStyle(BuildContext context) async {
    if (_initialized)
      return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _brightness = (prefs.getBool("isDark") ?? MediaQuery.of(context).platformBrightness == Brightness.dark) ? Brightness.dark: Brightness.light;
    _accentColor = Color(prefs.getInt("accentColor") ?? 0xff8e24aa);

    _initialized = true;
    notifyListeners();
  }

  Brightness get brightness => _brightness;
  set brightness (Brightness newBrightness) {
    _brightness = newBrightness;
    notifyListeners();
  }

  Future toggleBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_brightness == Brightness.dark)
      brightness = Brightness.light;
    else 
      brightness = Brightness.dark;

    prefs.setBool("isDark", _brightness == Brightness.dark);
  }

  bool get isDark => _brightness == Brightness.dark;

  Color get scaffoldColor => brightness == Brightness.light ? _lightScaffoldColor : _darkScaffoldColor;
  Color get primaryColor => brightness == Brightness.light ? _lightPrimaryColor : _darkPrimaryColor;
  Color get cardColor => brightness == Brightness.light ? _lightCardColor : _darkCardColor;
  Color get accentColor => _accentColor;

  set accentColor(Color newColor) {
    _accentColor = newColor;
    notifyListeners();
  }

  Future changeAccentColor(Color newColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    accentColor = newColor;

    prefs.setInt("accentColor", accentColor.value);
  }
}