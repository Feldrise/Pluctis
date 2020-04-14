import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';

class Plant with ChangeNotifier {
  Plant({this.id,
         @required this.slug,
         @required this.name,
         this.currentLocation,
         @required this.winterCycle,
         @required this.springCycle,
         @required this.summerCycle,
         @required this.autumnCycle,
         this.infoPlantation,
         this.infoWatering,
         this.infoExposure,
  });


  int id;
  String slug;
  String name;
  String currentLocation;
  
  // bool isAlive;
  int winterCycle; // In days
  int springCycle; // In days
  int summerCycle; // In days
  int autumnCycle; // In days

  String infoPlantation;
  String infoWatering;
  String infoExposure;

  // Setters

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }

  void setCurrentLocation(String newLocation) {
    currentLocation = newLocation;
    notifyListeners();
  }

  void setWinterCycle(int newCycle) {
    winterCycle = newCycle;
    notifyListeners();
  }

  void setSpringCycle(int newCycle) {
    springCycle = newCycle;
    notifyListeners();
  }

  void setSummerCycle(int newCycle) {
    summerCycle = newCycle;
    notifyListeners();
  }

  void setAutumnCycle(int newCycle) {
    autumnCycle = newCycle;
    notifyListeners();
  }

  // Utility functions
  
  // convenience constructor to create a Plant object
  Plant.fromMap(Map<String, dynamic> map) {
    id = map[plantColumnId];
    slug = map[plantColumnSlug];
    name = map[plantColumnName];
    currentLocation = map[plantColumnCurrentLocation];
    
    winterCycle = map[plantColumnWinterCycle];
    springCycle = map[plantColumnSpringCycle];
    summerCycle = map[plantColumnSummerCycle];
    autumnCycle = map[plantColumnAutumnCycle];

    infoPlantation = map[plantInfoColunmPlantation];
    infoWatering = map[plantInfoColunmWatering];
    infoExposure = map[plantInfoColunmExposure];
    // recommandedPot = recommandedPotForPlant(slug);
    // recommandedWaterQuantity = recommandedWaterQuantityForPlant(slug);
    // recommandedSunExposure = recommandedSunExposureForPlant(slug);
  }

  // convenience method to create a Map from this Plant object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      plantColumnSlug: slug,
      plantColumnName: name,
      plantColumnCurrentLocation: currentLocation,
      plantColumnWinterCycle: winterCycle,
      plantColumnSpringCycle: springCycle,
      plantColumnSummerCycle: summerCycle,
      plantColumnAutumnCycle: autumnCycle,
    };
    if (id != null) {
      map[plantColumnId] = id;
    }
    return map;
  }
}