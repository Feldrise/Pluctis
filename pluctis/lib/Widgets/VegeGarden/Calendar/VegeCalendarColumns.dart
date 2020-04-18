import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';

class VegeCalendarColumns extends StatelessWidget {

  const VegeCalendarColumns({
    this.tileHeight = 16,
    this.tileWidth = 31,
    this.sowMonths,
    this.plantationMonths,
    this.harvestMonths,
  });

  final double tileHeight;
  final double tileWidth;

  final List<String> sowMonths;
  final List<String> plantationMonths;
  final List<String> harvestMonths;

  Widget calendarItem(Color color) {
    return Container(
      alignment: Alignment.center,
      height: tileHeight,
      width: tileWidth,
      color: color,
      margin: EdgeInsets.all(2),
    );
  }

  List<Widget> buildColumns() {
    List<Widget> columns = [];

    for (int i = 0; i < 12; ++i) {
      final Month currentMonth = monthFromNumber[i + 1];
      List<Widget> columnItems = [];

      // We add the label
      columnItems.add(
        Container(
          alignment: Alignment.center,
          height: tileHeight,
          width: tileWidth,
          margin: EdgeInsets.all(2.0),
          child: Text(monthSlug[currentMonth].substring(0, 1).toUpperCase()),
        )
      );

      if (sowMonths != null && sowMonths.isNotEmpty) {
        if (sowMonths.contains(monthSlug[currentMonth])) {
          columnItems.add(calendarItem(Colors.yellow));
        }
        else {
          columnItems.add(calendarItem(Colors.grey));
        }
      }

      if (plantationMonths != null && plantationMonths.isNotEmpty) {
        if (plantationMonths.contains(monthSlug[currentMonth])) {
          columnItems.add(calendarItem(Colors.brown));
        }
        else {
          columnItems.add(calendarItem(Colors.grey));
        }
      }

      if (harvestMonths != null && harvestMonths.isNotEmpty) {
        if (harvestMonths.contains(monthSlug[currentMonth])) {
          columnItems.add(calendarItem(Colors.green));
        }
        else {
          columnItems.add(calendarItem(Colors.grey));
        }
      }

      columns.add(Column(children: columnItems,));
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: buildColumns(),
      ),
    );
  }
}