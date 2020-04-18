import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegeProblem.dart';

class Vegetable with ChangeNotifier {
  Vegetable({
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
}