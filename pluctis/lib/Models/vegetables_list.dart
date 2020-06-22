import 'package:flutter/material.dart';
import 'package:pluctis/helpers/database_helper.dart';
import 'package:pluctis/helpers/notification_helper.dart';
import 'package:pluctis/models/vegetable.dart';

class VegetablesList with ChangeNotifier {
  List<Vegetable> allVegetables = [];

  Future loadFromDatabase() async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    
    allVegetables = await helper.queryAllVegetable();

    notifyListeners();
  }
  
  Future addVegetable(Vegetable newVegetable) async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    newVegetable.id = await helper.insertVegetable(newVegetable);
    allVegetables.add(newVegetable);

    await notificationHelper.prepareDailyNotifications();
    
    notifyListeners();
  }

  Future removeVegetable(Vegetable vegetableToRemove) async {
    final DatabaseHelper helper = DatabaseHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    helper.deleteVegetable(vegetableToRemove);
    allVegetables.remove(vegetableToRemove);
        
    await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }
}