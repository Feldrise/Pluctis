import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Widgets/ItemsCard.dart';
import 'package:pluctis/Widgets/UrlItemsCard.dart';
import 'package:provider/provider.dart';

class PlantInfoColumn extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Informations", style: Theme.of(context).textTheme.title,),
              UrlItemsCard(
                title: "Nos sources : ",
                urls: plant.sourcesLinks,
              ),

              ItemsCard(
                icons: ['pot'],
                titles: ["Conseil de plantation"],
                contents: [plant.infoPlantation],
              ),

              ItemsCard(
                icons: ['water_cycle'],
                titles: ["Conseil d'arrosage"],
                contents: [plant.infoWatering],
              ),

              ItemsCard(
                icons: ['sun_exposure'],
                titles: ["Conseil pour l'exposition"],
                contents: [plant.infoExposure],
              )
            ],
          ),
        );
      },
    );
  }
}