import 'package:flutter/material.dart';
import 'package:pluctis/helpers/database_helper.dart';
import 'package:pluctis/helpers/notification_helper.dart';
import 'package:pluctis/helpers/plants_info_helper.dart';
import 'package:pluctis/helpers/timeline_helper.dart';

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

  void updateWateringFromCycleChange() {
    final TimelineHelper helper = TimelineHelper.instance;
    final NotificationHelper notificationHelper = NotificationHelper.instance;

    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10);
    
    if (nextWatering.difference(now) > const Duration()) {
      final Duration remaining = nextWatering.difference(now);
      final DateTime lastWatered = nextWatering.subtract(remaining);

      nextWatering = helper.nextWateringForPlant(lastWatered, this);
      notificationHelper.prepareDailyNotifications();
    }
  }
  void setWinterCycle(int newCycle) {
    if (nextWatering != null) {
      updateWateringFromCycleChange();
    }

    winterCycle = newCycle;
    notifyListeners();
  }

  void setSpringCycle(int newCycle) {
    if (nextWatering != null) {
      updateWateringFromCycleChange();
    }

    springCycle = newCycle;
    notifyListeners();
  }

  void setSummerCycle(int newCycle) {
    if (nextWatering != null) {
      updateWateringFromCycleChange();
    }

    summerCycle = newCycle;
    notifyListeners();
  }

  void setAutumnCycle(int newCycle) {
    if (nextWatering != null) {
      updateWateringFromCycleChange();
    }

    autumnCycle = newCycle;
    notifyListeners();
  }

  // Utility functions
  Future updateDatabase() async {
    final DatabaseHelper helper = DatabaseHelper.instance;

    await helper.updatePlant(this);
  }
  
  // convenience constructor to create a Plant object
  Plant.fromMap(Map<String, dynamic> map) {
    id = map[plantColumnId] as int;
    slug = map[plantColumnSlug] as String;
    name = map[plantColumnName] as String;
    currentLocation = map[plantColumnCurrentLocation] as String;
    
    winterCycle = map[plantColumnWinterCycle] as int;
    springCycle = map[plantColumnSpringCycle] as int;
    summerCycle = map[plantColumnSummerCycle] as int;
    autumnCycle = map[plantColumnAutumnCycle] as int;

    if (map[plantColumnNextWatering] != null) {
      nextWatering = DateTime.fromMillisecondsSinceEpoch(map[plantColumnNextWatering] as int);
    }

    infoPlantation = map[plantInfoColunmPlantation] as String;
    infoWatering = map[plantInfoColunmWatering] as String;
    infoExposure = map[plantInfoColunmExposure] as String;

    goodAnimals = map[plantInfoColunmGoodAnimals] as String;
    disease = map[plantInfoColumnDisease] as String;
    badAnimals = map[plantInfoColumnBadAnimals] as String;

    if (map[plantInfoColumnSourcesLinks] != null) {
      final String sourcesLinkString = map[plantInfoColumnSourcesLinks] as String;
      sourcesLinks = sourcesLinkString.split('\\');
    }
  }

  // convenience method to create a Map from this Plant object
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
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