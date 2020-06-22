import 'package:flutter/material.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/widgets/items_card.dart';
import 'package:pluctis/widgets/items_title_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:pluctis/widgets/vege_garden/calendar/vege_calendar.dart';
import 'package:provider/provider.dart';

class VegeIdentityColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Identité"),
              ItemsTitleCard(
                imageSource: "assets/images/vegetables/${vegetable.slug}.png",
                titles: [
                  vegetable.name,
                  "Les étapes"
                ],
                contents: [
                  "Nom",
                  " • Actuellement : ${vegetable.currentState}\n • Prochaine étape : ${TimelineHelper.instance.vegetableNextState(vegetable)}"
                ],
              ),
              
              ItemsCard(
                icons: const ["vegetables"],
                titles: const ["Description"],
                contents: [vegetable.description],
              ),

              VegeCalendar(
                tileHeight: 20,
                tileWidth: 14,
                labelWidth: 64,
                sowMonths: vegetable.sowMonths,
                plantationMonths: vegetable.plantMonths,
                harvestMonths: vegetable.harvestMonths,
              ),

              const SizedBox(height: 64,)
            ],
          ),
        );
      },
    );
  }
}