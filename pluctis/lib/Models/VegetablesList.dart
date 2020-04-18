import 'package:flutter/material.dart';
import 'package:pluctis/Models/Vegetable.dart';

class VegetablesList with ChangeNotifier {
  List<Vegetable> allVegetables = [
    Vegetable(
      slug: "carrots",  
      name: "My Carrots 1",
      description: "These are carrots",
      currentState: "Semi"
    ),
    Vegetable(
      slug: "carrots",  
      name: "My Carrots 2",
      description: "These are carrots",
      currentState: "Semi"
    ),
  ];
}