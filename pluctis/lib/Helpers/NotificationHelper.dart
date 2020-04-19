
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/Vegetable.dart';
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

  Future _preparePlantsNotifications(DateTime now, TimeOfDay notifHour) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Plant> toNotifie = await helper.queryAllPlants();
    List<int> notifiedDate = [];
    int currentId = 0;
    
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

  Future _prepareVegetablesNotifications(DateTime now, TimeOfDay notifHour) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Vegetable> toNotifie = await helper.queryAllVegetable();
    int currentId = 1000; // User may not have more than a thousand pants...

    String notificationText = "";

    for (var vegetable in toNotifie) {
      int nextMonthInt = (DateTime.now().month < 12) ? (DateTime.now().month + 1) : 1;
      DateTime nextMonth;
      bool haveNextState = false;

      do {
        // If we don't find a next state we should leave the loop anyway
        if (nextMonthInt == DateTime.now().month)
          break;

        nextMonth = DateTime(DateTime.now().year + ((nextMonthInt < DateTime.now().month) ? 1 : 0), nextMonthInt, 1, 10, 00);
        String nextMonthSlug = monthSlug[monthFromNumber[nextMonthInt]];
        String currentMonthSlug = monthSlug[monthFromNumber[DateTime.now().month]];

        if (vegetable.sowMonths.contains(nextMonthSlug) && (!vegetable.sowMonths.contains(currentMonthSlug) || nextMonthInt < DateTime.now().month)) {
          notificationText =  "Vous allez bientôt pouvoir passer à l'étape de semi pour les ${vegetable.name.toLowerCase()}."; 
          haveNextState = true;
        }

        if (vegetable.plantMonths.contains(nextMonthSlug) && !vegetable.plantMonths.contains(currentMonthSlug)) {
          notificationText = "Vous allez bientôt pouvoir passer à l'étape de plantation pour les ${vegetable.name.toLowerCase()}.";
          haveNextState = true;
        }

        if (vegetable.harvestMonths.contains(nextMonthSlug) && !vegetable.harvestMonths.contains(currentMonthSlug)) {
          notificationText = "Vous allez bientôt pouvoir passer à l'étape de cueillette pour les ${vegetable.name.toLowerCase()}.";
          haveNextState = true;
        }

        nextMonthInt = (nextMonthInt < 12) ? nextMonthInt + 1 : 1;

      } while(!haveNextState);

      if (haveNextState) {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails('plantChannelId', 'plantChannel', 'Le salon de notification des plantes à arroser');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        
        
        await flutterLocalNotificationsPlugin.schedule(
          currentId,
          'Pluctis',
          notificationText,
          nextMonth,
          platformChannelSpecifics,
          androidAllowWhileIdle: true);

        currentId++;
      }
    }
  }

  Future prepareDailyNotifications() async {
    if (flutterLocalNotificationsPlugin == null) {
      _initNotifications();
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TimeOfDay  notifHour = TimeOfDay(hour: prefs.getInt("notifHour") ?? 10, minute: prefs.getInt("notifMinute") ?? 00);
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, notifHour.hour, notifHour.minute);
    
    await flutterLocalNotificationsPlugin.cancelAll();

    await _preparePlantsNotifications(now, notifHour);
    await _prepareVegetablesNotifications(now, notifHour);

  }

}