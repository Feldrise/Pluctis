import 'package:flutter/material.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/vege_garden/calendar/vege_calendar_columns.dart';
import 'package:pluctis/widgets/vege_garden/calendar/vege_calendar_label.dart';

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
    return PluctisCard(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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