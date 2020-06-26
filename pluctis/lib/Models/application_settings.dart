import 'package:flutter/material.dart';
import 'package:pluctis/helpers/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettings with ChangeNotifier {
  var _initialized = false;

  var _brightness = Brightness.light;

  final _lightScaffoldColor = const Color(0xffffffff);
  final _darkScaffoldColor = const Color(0xff23272F);

  final _lightPrimaryColor = const Color(0xffffffff);
  final _darkPrimaryColor = const Color(0xff2C313B);

  final _lightCardColor = const Color(0xffffffff);
  final _darkCardColor = const Color(0xff2C313B);

  var _accentColor = const Color(0xffd81b60);

  bool _useOldDashboard = false;

  TimeOfDay _notificationTime = const TimeOfDay(hour: 10, minute: 00);

  Future initSettings(BuildContext context) async {
    if (_initialized) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _brightness = (prefs.getBool("isDark") ?? MediaQuery.of(context).platformBrightness == Brightness.dark) ? Brightness.dark: Brightness.light;
    _accentColor = Color(prefs.getInt("accentColor") ?? 0xffd81b60);

    _notificationTime = TimeOfDay(hour: prefs.getInt("notifHour") ?? 10, minute: prefs.getInt("notifMinute") ?? 00);

    _useOldDashboard = prefs.getBool("useOldDashboard") ?? false;

    _initialized = true;
    notifyListeners();
  }

  Brightness get brightness => _brightness;
  set brightness (Brightness newBrightness) {
    _brightness = newBrightness;
    notifyListeners();
  }

  Future toggleBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_brightness == Brightness.dark) {
      brightness = Brightness.light;
    }
    else { 
      brightness = Brightness.dark;
    }

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    accentColor = newColor;

    prefs.setInt("accentColor", accentColor.value);
  }

  TimeOfDay get notificationTime => _notificationTime;
  int get notificationHour => _notificationTime.hour;
  int get notificationMinute => _notificationTime.minute;

  Future updateNotificationTime(TimeOfDay newTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _notificationTime = newTime;

    prefs.setInt("notifHour", _notificationTime.hour);
    prefs.setInt("notifMinute", _notificationTime.minute);

    await NotificationHelper.instance.prepareDailyNotifications();
    notifyListeners();
  }

  bool get useOldDashboard => _useOldDashboard;
  Future changeUseOfDashboard({bool useOldDashboard}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("useOldDashboard", useOldDashboard);
    _useOldDashboard = useOldDashboard;

    notifyListeners();
  }
}