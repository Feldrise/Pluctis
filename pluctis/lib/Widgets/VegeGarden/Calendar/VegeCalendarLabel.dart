import 'package:flutter/material.dart';

class VegeCalendarLabel extends StatelessWidget {
  const VegeCalendarLabel({
    this.tileHeight = 16,
    this.tileWidth = 32,
    this.showSowLabel = false,
    this.showPlantationLabel = false,
    this.showHarvestLabel = false,
  });

  final double tileHeight;
  final double tileWidth;

  final bool showSowLabel;
  final bool showPlantationLabel;
  final bool showHarvestLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: tileHeight,
          width: tileWidth,
          margin: EdgeInsets.all(2.0),
          child: Text(""),
        ),
        Visibility(
          visible: showSowLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: EdgeInsets.all(2.0),
            child: Text("Semi"),
          )
        ),
        Visibility(
          visible: showPlantationLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: EdgeInsets.all(2.0),
            child: Text("Plantation"),
          )
        ),
        Visibility(
          visible: showHarvestLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: EdgeInsets.all(2.0),
            child: Text("Cueilette"),
          )
        ),
      ],
    );
  }
}