
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {

  NotificationHelper._privateConstructor();
  static final NotificationHelper instance = NotificationHelper._privateConstructor();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  
  void _initNotifications() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher'); 
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future prepareDailyNotifications() async {
    if (flutterLocalNotificationsPlugin == null) {
      _initNotifications();
    }

    DatabaseHelper helper = DatabaseHelper.instance;
    List<Plant> toNotifie = await helper.queryAllPlants();
    List<int> notifiedDate = [];
    int currentId = 0;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TimeOfDay  notifHour = TimeOfDay(hour: prefs.getInt("notifHour") ?? 10, minute: prefs.getInt("notifMinute") ?? 00);
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, notifHour.hour, notifHour.minute);
    
    await flutterLocalNotificationsPlugin.cancelAll();

    for (var plant in toNotifie) {
      DateTime notificationTime = DateTime(plant.nextWatering.year, plant.nextWatering.month, plant.nextWatering.day, notifHour.hour, notifHour.minute);

      if (notificationTime.isBefore(now) || notificationTime.isAtSameMomentAs(now)) {
        continue;
      }

      if (!notifiedDate.contains(notificationTime.millisecondsSinceEpoch)) {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails('plantChannelId', 'plantChannel', 'Le salon de notification des plantes à arroser');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        
        await flutterLocalNotificationsPlugin.schedule(
            currentId,
            'Pluctis',
            'Vous avez des plantes à arroser aujourd\'hui !',
            notificationTime,
            platformChannelSpecifics,
            androidAllowWhileIdle: true);

        notifiedDate.add(notificationTime.millisecondsSinceEpoch);
        currentId++;
      }
    }
  }

}