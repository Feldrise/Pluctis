import 'package:flutter/material.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/widgets/items_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class VegeInfoColumn extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Informations"),
              ItemsCard(
                icons: const ['sowing'],
                titles: const ["La semis"],
                contents: [vegetable.infoSowing],
              ),

              ItemsCard(
                icons: const ['growing'],
                titles: const ["Quand la plante pousse"],
                contents: [vegetable.infoGrowing],
              ),

              ItemsCard(
                icons: const ['harvesting'],
                titles: const ["La cueillette"],
                contents: [vegetable.infoHarvesting],
              )
            ],
          ),
        );
      },
    );
  }
}