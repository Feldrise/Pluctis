import 'package:flutter/material.dart';
import 'package:pluctis/helpers/database_helper.dart';
import 'package:pluctis/helpers/notification_helper.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/plant.dart';

class PlantsList with ChangeNotifier {
  List<Plant> allPlants = [];

  Future loadFromDatabase() async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    allPlants = await helper.queryAllPlants();

    notifyListeners();
  }
  
  Future addPlant(Plant newPlant) async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    newPlant.id = await helper.insertPlant(newPlant);
    allPlants.add(newPlant);

    await notificationHelper.prepareDailyNotifications();
    
    notifyListeners();
  }

  Future removePlant(Plant plantToRemove) async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    helper.deletePlant(plantToRemove);
    allPlants.remove(plantToRemove);
        
    await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }

  Future updatePlantWatering(DateTime lastWatered, Plant plant) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final TimelineHelper timelineHelper = TimelineHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    plant.nextWatering = timelineHelper.nextWateringForPlant(lastWatered, plant);

    await databaseHelper.updatePlant(plant);
    await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }
}