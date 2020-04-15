import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/DatabaseHelper.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';

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

  DateTime nextWatering;

  List<String> sourcesLinks = [];

  String infoPlantation;
  String infoWatering;
  String infoExposure;
  
  String goodAnimals;
  String disease;
  String badAnimals;

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
    if (nextWatering != null) {
      TimelineHelper helper = TimelineHelper.instance;

      DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
      
      if (nextWatering.difference(now) > Duration(days: 0)) {
        Duration remaining = nextWatering.difference(now);
        DateTime lastWatered = nextWatering.subtract(remaining);

        nextWatering = helper.nextWateringForPlant(lastWatered, this);
      }
    }

    winterCycle = newCycle;
    notifyListeners();
  }

  void setSpringCycle(int newCycle) {
    if (nextWatering != null) {
      TimelineHelper helper = TimelineHelper.instance;

      DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
      
      if (nextWatering.difference(now) > Duration(days: 0)) {
        Duration remaining = nextWatering.difference(now);
        DateTime lastWatered = nextWatering.subtract(remaining);

        nextWatering = helper.nextWateringForPlant(lastWatered, this);
      }
    }

    springCycle = newCycle;
    notifyListeners();
  }

  void setSummerCycle(int newCycle) {
    if (nextWatering != null) {
      TimelineHelper helper = TimelineHelper.instance;

      DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
      
      if (nextWatering.difference(now) > Duration(days: 0)) {
        Duration remaining = nextWatering.difference(now);
        DateTime lastWatered = nextWatering.subtract(remaining);

        nextWatering = helper.nextWateringForPlant(lastWatered, this);
      }
    }

    summerCycle = newCycle;
    notifyListeners();
  }

  void setAutumnCycle(int newCycle) {
    if (nextWatering != null) {
      TimelineHelper helper = TimelineHelper.instance;

      DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
      
      if (nextWatering.difference(now) > Duration(days: 0)) {
        Duration remaining = nextWatering.difference(now);
        DateTime lastWatered = nextWatering.subtract(remaining);

        nextWatering = helper.nextWateringForPlant(lastWatered, this);
      }
    }

    autumnCycle = newCycle;
    notifyListeners();
  }

  void setNextWatering(DateTime newDate) {
    nextWatering = newDate;
  }

  // Utility functions
  Future updateDatabase() async {
    DatabaseHelper helper = DatabaseHelper.instance;

    await helper.updatePlant(this);
  }
  
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

    if (map[plantColumnNextWatering] != null)
      nextWatering = DateTime.fromMillisecondsSinceEpoch(map[plantColumnNextWatering]);

    infoPlantation = map[plantInfoColunmPlantation];
    infoWatering = map[plantInfoColunmWatering];
    infoExposure = map[plantInfoColunmExposure];

    goodAnimals = map[plantInfoColunmGoodAnimals];
    disease = map[plantInfoColumnDisease];
    badAnimals = map[plantInfoColumnBadAnimals];

    if (map[plantInfoColumnSourcesLinks] != null) {
      String sourcesLinkString = map[plantInfoColumnSourcesLinks];
      sourcesLinks = sourcesLinkString.split(',');
    }
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
      plantColumnNextWatering: nextWatering.millisecondsSinceEpoch,
    };
    if (id != null) {
      map[plantColumnId] = id;
    }
    return map;
  }
}