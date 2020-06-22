import 'package:flutter/material.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/helpers/vege_info_helper.dart';
import 'package:pluctis/models/vege_problem.dart';

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
    slug = map[vegeInfoColumnSlug] as String;
    name = map[vegeInfoColumnName] as String;
    description = map[vegeInfoColumnDescription] as String;
    
    infoSowing = map[vegeInfoColumnSowing] as String;
    infoGrowing = map[vegeInfoColumnGrowing] as String;
    infoHarvesting = map[vegeInfoColumnHarvesting] as String;

    if (map[vegeInfoColumnSowMonths] != null) {
      final String sowMonthsString = map[vegeInfoColumnSowMonths] as String;
      sowMonths = sowMonthsString.split(',');

      if (sowMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]])) {
        currentState = "Semis";
      }
    }

    if (map[vegeInfoColumnPlantMonths] != null) {
      final String plantMonthsString = map[vegeInfoColumnPlantMonths] as String;
      plantMonths = plantMonthsString.split(',');

      if (plantMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]])) {
        currentState = "Plantation";
      }
    }

    if (map[vegeInfoColumnHarvestMonths] != null) {
      final String harvestMonthsString = map[vegeInfoColumnHarvestMonths] as String;
      harvestMonths = harvestMonthsString.split(',');

      if (harvestMonths.contains(monthSlug[monthFromNumber[DateTime.now().month]])) {
        currentState = "Cueillette";
      }
    }

  }
}