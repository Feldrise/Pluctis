import 'package:flutter/material.dart';
import 'package:pluctis/Widgets/VegeGarden/Calendar/VegeCalendarColumns.dart';
import 'package:pluctis/Widgets/VegeGarden/Calendar/VegeCalendarLabel.dart';

class VegeCalendar extends StatelessWidget {
  const VegeCalendar({
    this.tileHeight = 16,
    this.tileWidth = 32,
    this.labelWidth = 24,
    this.sowMonths,
    this.plantationMonths,
    this.harvestMonths,
  });

  final double tileHeight;
  final double tileWidth;
  final double labelWidth;

  final List<String> sowMonths;
  final List<String> plantationMonths;
  final List<String> harvestMonths;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VegeCalendarLabel(
              tileHeight: tileHeight,
              tileWidth: labelWidth,
              showSowLabel: sowMonths != null && sowMonths.isNotEmpty,
              showPlantationLabel: plantationMonths != null && plantationMonths.isNotEmpty,
              showHarvestLabel: harvestMonths != null && harvestMonths.isNotEmpty,
            ),
            VegeCalendarColumns(
              tileHeight: tileHeight,
              tileWidth: tileWidth,
              sowMonths: sowMonths,
              plantationMonths: plantationMonths,
              harvestMonths: harvestMonths,
            )
          ],
        ),
      ),
    );
  }
}