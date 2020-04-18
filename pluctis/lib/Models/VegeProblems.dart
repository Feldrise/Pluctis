import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/VegeInfoHelper.dart';

class VegeProblems {
  VegeProblems({
    @required this.slug,
    @required this.name,
    @required this.symptoms,
    @required this.remedy,
  });

  String slug;
  String name;

  String symptoms;
  String remedy;

  VegeProblems.fromMap(Map<String, dynamic> map) {
    slug = map[vegeProblemsColumnSlug];
    name = map[vegeProblemsColumnName];

    symptoms = map[vegeProblemsColumnSymptoms];
    remedy = map[vegeProblemsColumnRemedy];
  }
}