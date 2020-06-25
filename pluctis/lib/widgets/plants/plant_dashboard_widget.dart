import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:provider/provider.dart';

class PlantDashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return PluctisCard(
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(64),
                child: Image(
                  image: AssetImage("assets/images/plants/${plant.slug}.png"),
                  width: 128,
                  height: 128,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 12,),
              // The plant name
              Text(plant.name, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
              const SizedBox(height: 32,),
              // The plant next wattering
              const Icon(FontAwesomeIcons.tint),
              const SizedBox(height: 16,),
              Text(TimelineHelper.instance.remainingDaysString(plant), style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,),
              // The plant detail button
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    onPressed: () async {
                      await Provider.of<PlantsList>(context, listen: false).updatePlantWatering(DateTime.now(), plant);
                      
                      // We show an ad, with 1/2 chances to appear
                      final AdsHelper adsHelper = AdsHelper.instance;
                      await adsHelper.showInterstitialAd(chanceToShow: 2);
                    },
                    child: Text("Je l'ai arrosée", style: TextStyle(color: Theme.of(context).accentColor)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}