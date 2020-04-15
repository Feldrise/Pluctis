import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Widgets/ItemsCard.dart';
import 'package:provider/provider.dart';

class PlantHealthColumn extends StatelessWidget {
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
              Text("Santée", style: Theme.of(context).textTheme.title,),
              // We only show this if there is no data for health
              Visibility(
                visible: 
                  (plant.goodAnimals == null || plant.goodAnimals.isEmpty) &&
                  (plant.disease == null || plant.disease.isEmpty) &&
                  (plant.badAnimals == null || plant.badAnimals.isEmpty),
                child: Flexible(
                  child: Center(
                    child: Text("Il n'y à pas d'information sur la santé de votre plante.", textAlign: TextAlign.center,),
                  )
                )
              ),

              // We show data for health
              Visibility(
                visible: plant.goodAnimals != null && plant.goodAnimals.isNotEmpty,
                child: ItemsCard(
                  icons: ['bee'],
                  titles: ["Les bons animaux"],
                  contents: [plant.goodAnimals],
                ),
              ),

              Visibility(
                visible: plant.disease != null && plant.disease.isNotEmpty,
                child: ItemsCard(
                  icons: ['crying'],
                  titles: ["Les maladies"],
                  contents: [plant.disease],
                ),
              ),

              Visibility(
                visible: plant.badAnimals != null && plant.badAnimals.isNotEmpty,
                child: ItemsCard(
                  icons: ['poux'],
                  titles: ["Les mauvais animaux"],
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