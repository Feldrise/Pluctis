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
          margin: const EdgeInsets.all(2.0),
          child: const Text(""),
        ),
        Visibility(
          visible: showSowLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: const EdgeInsets.all(2.0),
            child: const Text("Semis"),
          )
        ),
        Visibility(
          visible: showPlantationLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: const EdgeInsets.all(2.0),
            child: const Text("Plantation"),
          )
        ),
        Visibility(
          visible: showHarvestLabel,
          child: Container(
            alignment: Alignment.center,
            height: tileHeight,
            width: tileWidth,
            margin: const EdgeInsets.all(2.0),
            child: const Text("Cueillette"),
          )
        ),
      ],
    );
  }
}