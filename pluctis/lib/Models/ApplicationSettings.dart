import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/NotificationHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettings with ChangeNotifier {
  var _initialized = false;

  var _brightness = Brightness.light;

  var _lightScaffoldColor = Color(0xffffffff);
  var _darkScaffoldColor = Color(0xff23272F);

  var _lightPrimaryColor = Color(0xffffffff);
  var _darkPrimaryColor = Color(0xff2C313B);

  var _lightCardColor = Color(0xffffffff);
  var _darkCardColor = Color(0xff2C313B);

  var _accentColor = Color(0xffd81b60);

  TimeOfDay _notificationTime = TimeOfDay(hour: 10, minute: 00);

  void initSettings(BuildContext context) async {
    if (_initialized)
      return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _brightness = (prefs.getBool("isDark") ?? MediaQuery.of(context).platformBrightness == Brightness.dark) ? Brightness.dark: Brightness.light;
    _accentColor = Color(prefs.getInt("accentColor") ?? 0xffd81b60);

    _notificationTime = TimeOfDay(hour: prefs.getInt("notifHour") ?? 10, minute: prefs.getInt("notifMinute") ?? 00);

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

  TimeOfDay get notificationTime => _notificationTime;
  int get notificationHour => _notificationTime.hour;
  int get notificationMinute => _notificationTime.minute;

  Future updateNotificationTime(TimeOfDay newTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _notificationTime = newTime;

    prefs.setInt("notifHour", _notificationTime.hour);
    prefs.setInt("notifMinute", _notificationTime.minute);

    await NotificationHelper.instance.prepareDailyNotifications();
    notifyListeners();
  }
}