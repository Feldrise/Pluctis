import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
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

    newPlant.id = await helper.insertPlant(newPlant);
    allPlants.add(newPlant);
    
    notifyListeners();
  }

  Future removePlant(Plant plantToRemove) async {
    DatabaseHelper helper = DatabaseHelper.instance;

    helper.deletePlant(plantToRemove);
    allPlants.remove(plantToRemove);
    
    notifyListeners();
  }
}