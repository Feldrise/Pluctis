import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';

class PlantsList with ChangeNotifier {
  List<Plant> allPlants = [];
  
  void addPlant(Plant newPlant) {
    allPlants.add(newPlant);

    notifyListeners();
  }
}