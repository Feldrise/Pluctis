import 'package:flutter/material.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/widgets/items_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class PlantHealthColumn extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Santé"),
              // We only show this if there is no data for health
              Visibility(
                visible: 
                  (plant.goodAnimals == null || plant.goodAnimals.isEmpty) &&
                  (plant.disease == null || plant.disease.isEmpty) &&
                  (plant.badAnimals == null || plant.badAnimals.isEmpty),
                child: const Flexible(
                  child: Center(
                    child: Text("Il n'y à pas d'information sur la santé de votre plante.", textAlign: TextAlign.center,),
                  )
                )
              ),

              // We show data for health
              Visibility(
                visible: plant.goodAnimals != null && plant.goodAnimals.isNotEmpty,
                child: ItemsCard(
                  icons: const ['bee'],
                  titles: const ["Les bons animaux"],
                  contents: [plant.goodAnimals],
                ),
              ),

              Visibility(
                visible: plant.disease != null && plant.disease.isNotEmpty,
                child: ItemsCard(
                  icons: const ['crying'],
                  titles: const ["Les maladies"],
                  contents: [plant.disease],
                ),
              ),

              Visibility(
                visible: plant.badAnimals != null && plant.badAnimals.isNotEmpty,
                child: ItemsCard(
                  icons: const ['poux'],
                  titles: const ["Les mauvais animaux"],
                  contents: [plant.badAnimals],
                )
              ),
            ],
          ),
        );
      },
    );
  }
}