import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/VegeInfoHelper.dart';

class VegeProblem {
  VegeProblem({
    @required this.slug,
    @required this.name,
    @required this.symptoms,
    @required this.remedy,
  });

  String slug;
  String name;

  String symptoms;
  String remedy;

  VegeProblem.fromMap(Map<String, dynamic> map) {
    slug = map[vegeProblemsColumnSlug];
    name = map[vegeProblemsColumnName];

    symptoms = map[vegeProblemsColumnSymptoms];
    remedy = map[vegeProblemsColumnRemedy];
  }
}