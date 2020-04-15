import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Helpers/NotificationHelper.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Models/Plant.dart';

class PlantsList with ChangeNotifier {
  List<Plant> allPlants = [];

  Future loadFromDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    allPlants = await helper.queryAllPlants();

    notifyListeners();
  }
  
  Future addPlant(Plant newPlant) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    NotificationHelper notificationHelper = NotificationHelper.instance;

    newPlant.id = await helper.insertPlant(newPlant);
    allPlants.add(newPlant);

    await notificationHelper.prepareDailyNotifications();
    
    notifyListeners();
  }

  Future removePlant(Plant plantToRemove) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    NotificationHelper notificationHelper = NotificationHelper.instance;

    helper.deletePlant(plantToRemove);
    allPlants.remove(plantToRemove);
        
    await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }

  Future updatePlantWatering(DateTime lastWatered, Plant plant) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    TimelineHelper timelineHelper = TimelineHelper.instance;
    NotificationHelper notificationHelper = NotificationHelper.instance;

    plant.setNextWatering(timelineHelper.nextWateringForPlant(lastWatered, plant));

    await databaseHelper.updatePlant(plant);
    await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }
}