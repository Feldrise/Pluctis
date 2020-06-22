import 'package:flutter/material.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/widgets/items_card.dart';
import 'package:pluctis/widgets/items_title_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class PlantIdentityColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Identité"),
              ItemsTitleCard(
                imageSource: "assets/images/plants/${plant.slug}.png",
                invert: true,
                titles: const [
                  "Nom",
                  "Lieu"
                ],
                contents: [
                  plant.name,
                  plant.currentLocation
                ],
                buttons: [
                  FlatButton(
                    onPressed: () {
                      // TODO: do
                      // print("Dead plant clicked");
                    },
                    child: Text("Ma plante est morte", style: TextStyle(color: Theme.of(context).accentColor),),
                  )
                ],
              ),
              ItemsCard(
                invert: true,
                icons: const [
                  'winter',
                  'spring',
                  'summer',
                  'autumn',
                ],
                titles: const [
                  "Cycle d'arrosage en hivers",
                  "Cycle d'arrosage au printemp",
                  "Cycle d'arrosage en été",
                  "Cycle d'arrosage en automne",
                ],
                contents: [
                  "${plant.winterCycle} jour(s)",
                  "${plant.springCycle} jour(s)",
                  "${plant.summerCycle} jour(s)",
                  "${plant.autumnCycle} jour(s)",
                ],
              )
            ],
          ),
        );
      },
    );
  }
}