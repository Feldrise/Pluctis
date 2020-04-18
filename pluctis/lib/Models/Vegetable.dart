import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegeProblems.dart';

class Vegetable with ChangeNotifier {
  String slug;
  String name;
  String description;

  List<String> sowMonths = [];
  List<String> plantMonths = [];
  List<String> harvestMonths = [];

  String infoSowing;
  String growSowing;
  String infoHarvesting;

  List<VegeProblems> problems = [];
}