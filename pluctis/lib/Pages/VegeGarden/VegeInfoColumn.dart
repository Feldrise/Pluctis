import 'package:flutter/material.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Widgets/ItemsCard.dart';
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
              Text("Informations", style: Theme.of(context).textTheme.title,),
              ItemsCard(
                icons: ['pot'],
                titles: ["La semi"],
                contents: [vegetable.infoSowing],
              ),

              ItemsCard(
                icons: ['water_cycle'],
                titles: ["Quand la plante pousse"],
                contents: [vegetable.infoGrowing],
              ),

              ItemsCard(
                icons: ['sun_exposure'],
                titles: ["La cueilette"],
                contents: [vegetable.infoHarvesting],
              )
            ],
          ),
        );
      },
    );
  }
}