import 'package:flutter/material.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/widgets/items_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:pluctis/widgets/url_items_card.dart';
import 'package:provider/provider.dart';

class PlantInfoColumn extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Informations"),

              ItemsCard(
                icons: const ['pot'],
                titles: const ["Conseil de plantation"],
                contents: [plant.infoPlantation],
              ),

              ItemsCard(
                icons: const ['water_cycle'],
                titles: const ["Conseil d'arrosage"],
                contents: [plant.infoWatering],
              ),

              ItemsCard(
                icons: const ['sun_exposure'],
                titles: const ["Conseil pour l'exposition"],
                contents: [plant.infoExposure],
              ),

              UrlItemsCard(
                title: "Nos sources : ",
                urls: plant.sourcesLinks,
              ),

            ],
          ),
        );
      },
    );
  }
}