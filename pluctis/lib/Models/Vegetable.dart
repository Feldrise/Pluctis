import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Helpers/VegeInfoHelper.dart';
import 'package:pluctis/Models/VegeProblem.dart';

class Vegetable with ChangeNotifier {
  Vegetable({
    this.id,
    @required this.slug,
    @required this.name,
    @required this.description,
    this.sowMonths,
    this.plantMonths,
    this.harvestMonths,
    @required this.currentState,
    this.infoSowing,
    this.infoGrowing,
    this.infoHarvesting,
    this.problems
  });

  int id;
  String slug;
  String name;
  String description;

  List<String> sowMonths = [];
  List<String> plantMonths = [];
  List<String> harvestMonths = [];
  String currentState;

  String infoSowing;
  String infoGrowing;
  String infoHarvesting;

  List<VegeProblem> problems = [];

    // convenience constructor to create a Vegetable object
  Vegetable.fromMap(Map<String, dynamic> map) {
    slug = map[vegeInfoColumnSlug];
    name = map[vegeInfoColumnName];
    description = map[vegeInfoColumnDescription];
    
    infoSowing = map[vegeInfoColumnSowing];
    infoGrowing = map[vegeInfoColumnGrowing];
    infoHarvesting = map[vegeInfoColumnHarvesting];

    if (map[vegeInfoColumnSowMonths] != null) {
      String sowMonthsString = map[vegeInfoColumnSowMonths];
      sowMonths = sowMonthsString.split(',');

      if (sowMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]]))
        currentState = "Semi";
    }

    if (map[vegeInfoColumnPlantMonths] != null) {
      String plantMonthsString = map[vegeInfoColumnPlantMonths];
      plantMonths = plantMonthsString.split(',');

      if (plantMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]]))
        currentState = "Plantation";
    }

    if (map[vegeInfoColumnHarvestMonths] != null) {
      String harvestMonthsString = map[vegeInfoColumnHarvestMonths];
      harvestMonths = harvestMonthsString.split(',');

      if (harvestMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]]))
        currentState = "Cueillette";
    }

  }
}