import 'package:flutter/material.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Widgets/ItemsCard.dart';
import 'package:pluctis/Widgets/PluctisTitle.dart';
import 'package:provider/provider.dart';

class VegeInfoColumn extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PluctisTitle(title: "Informations"),
              ItemsCard(
                icons: ['sowing'],
                titles: ["La semis"],
                contents: [vegetable.infoSowing],
              ),

              ItemsCard(
                icons: ['growing'],
                titles: ["Quand la plante pousse"],
                contents: [vegetable.infoGrowing],
              ),

              ItemsCard(
                icons: ['harvesting'],
                titles: ["La cueillette"],
                contents: [vegetable.infoHarvesting],
              )
            ],
          ),
        );
      },
    );
  }
}