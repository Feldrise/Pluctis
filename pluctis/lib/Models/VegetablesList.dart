import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Models/Vegetable.dart';

class VegetablesList with ChangeNotifier {
  List<Vegetable> allVegetables = [];

  Future loadFromDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    
    allVegetables = await helper.queryAllVegetable();

    notifyListeners();
  }
  
  Future addVegetable(Vegetable newVegetable) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    // NotificationHelper notificationHelper = NotificationHelper.instance;

    newVegetable.id = await helper.insertVegetable(newVegetable);
    allVegetables.add(newVegetable);

    // await notificationHelper.prepareDailyNotifications();
    
    notifyListeners();
  }

  Future removeVegetable(Vegetable vegetableToRemove) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    // NotificationHelper notificationHelper = NotificationHelper.instance;

    helper.deleteVegetable(vegetableToRemove);
    allVegetables.remove(vegetableToRemove);
        
    // await notificationHelper.prepareDailyNotifications();

    notifyListeners();
  }
}