import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Models/ApplicationSettings.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:provider/provider.dart';

class PlantDashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Provider.of<ApplicationSettings>(context, listen: false).brightness == Brightness.dark ? Colors.black26 : Colors.black12,
                offset: const Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: Theme.of(context).scaffoldBackgroundColor,
                offset: const Offset(0.0, 0.0),
                spreadRadius: -10.0,
                blurRadius: 15.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 12,),
              // The plant name
              Text(plant.name, style: Theme.of(context).textTheme.headline, textAlign: TextAlign.center,),
              SizedBox(height: 12,),
              // The plant next wattering
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.tint),
                  Text(TimelineHelper.instance.remainingDaysString(plant), style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center,)
                ],
              ),
              // The plant detail button
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    child: Text("Je l'ai arrosée", style: TextStyle(color: Theme.of(context).accentColor)),
                    onPressed: () async {
                      print("watered button pressed");
                      await Provider.of<PlantsList>(context, listen: false).updatePlantWatering(DateTime.now(), plant);
                      
                      // We show an ad, with 1/2 chances to appear
                      AdsHelper adsHelper = AdsHelper.instance;
                      await adsHelper.showInterstitialAd(chanceToShow: 2);
                    },
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