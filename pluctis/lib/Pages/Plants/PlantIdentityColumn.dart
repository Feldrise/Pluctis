import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Widgets/ItemsCard.dart';
import 'package:pluctis/Widgets/ItemsTitleCard.dart';
import 'package:pluctis/Widgets/PluctisTitle.dart';
import 'package:provider/provider.dart';

class PlantIdentityColumn extends StatelessWidget {
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
              PluctisTitle(title: "Identité"),
              ItemsTitleCard(
                imageSource: "assets/images/plants/${plant.slug}.png",
                invert: true,
                titles: [
                  "Nom",
                  "Lieu"
                ],
                contents: [
                  plant.name,
                  plant.currentLocation
                ],
                buttons: [
                  FlatButton(
                    child: Text("Ma plante est morte", style: TextStyle(color: Theme.of(context).accentColor),),
                    onPressed: () {
                      print("Dead plant clicked");
                    },
                  )
                ],
              ),
              ItemsCard(
                invert: true,
                icons: [
                  'winter',
                  'spring',
                  'summer',
                  'autumn',
                ],
                titles: [
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