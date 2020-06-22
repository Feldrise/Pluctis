import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:provider/provider.dart';

class PlantDashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Provider.of<ApplicationSettings>(context, listen: false).brightness == Brightness.dark ? Colors.black26 : Colors.black12,
              ),
              BoxShadow(
                color: Theme.of(context).scaffoldBackgroundColor,
                spreadRadius: -10.0,
                blurRadius: 15.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image(
                  image: AssetImage("assets/images/plants/${plant.slug}.png"),
                  width: 64,
                  height: 64,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 12,),
              // The plant name
              Text(plant.name, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
              const SizedBox(height: 12,),
              // The plant next wattering
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(FontAwesomeIcons.tint),
                  Text(TimelineHelper.instance.remainingDaysString(plant), style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,)
                ],
              ),
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