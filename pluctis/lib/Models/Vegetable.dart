import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegeProblems.dart';

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
    this.growSowing,
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
  String growSowing;
  String infoHarvesting;

  List<VegeProblems> problems = [];
}