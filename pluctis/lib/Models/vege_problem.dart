import 'package:flutter/material.dart';
import 'package:pluctis/helpers/vege_info_helper.dart';

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
    slug = map[vegeProblemsColumnSlug] as String;
    name = map[vegeProblemsColumnName] as String;

    symptoms = map[vegeProblemsColumnSymptoms] as String;
    remedy = map[vegeProblemsColumnRemedy] as String;
  }
}