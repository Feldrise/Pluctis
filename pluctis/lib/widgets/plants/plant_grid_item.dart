import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/pages/plants/plant_details_page.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:provider/provider.dart';

class PlantGridItem extends StatelessWidget {
  const PlantGridItem({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Container(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // The card content
              PluctisCard(
                margin: const EdgeInsets.only(top: 46, bottom: 8, left: 8, right: 8),
                padding: const EdgeInsets.only(top: 46, bottom: 8, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // The plant name
                    Expanded(
                      flex: 2,
                      child: Center(child: Text(plant.name, style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,)),
                    ),
                    // The plant next wattering
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(FontAwesomeIcons.tint),
                          Text(TimelineHelper.instance.remainingDaysString(plant), style: Theme.of(context).textTheme.subtitle1,)
                        ],
                      ),
                    ),
                    // The plant detail button
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                                value: plant,
                                child: PlantDetailsPage(),
                              )),
                            );
                          },
                          child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // The plant Image
              Positioned(
                left: 16,
                right: 16,
                child: Align(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: Image(
                      image: AssetImage("assets/images/plants/${plant.slug}.png"), 
                      height: 92,
                      width: 92,
                      fit: BoxFit.fitHeight,
                    ),
                ),
                ),
              )
            ],
          ),
        );
      } 
    );
  }
}