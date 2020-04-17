import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Pages/Plants/PlantDetailsPage.dart';
import 'package:provider/provider.dart';

class PlantGridItem extends StatelessWidget {
  const PlantGridItem({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // The plant image
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(0)),
                  child: Image(
                    // colorBlendMode: _plant.isAlive ? null : BlendMode.darken,
                    // color: _plant.isAlive ? null : Colors.black54,
                    // width: 25,
                    image: AssetImage("assets/images/plants/${plant.slug}.png"), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // The plant name
              Expanded(
                flex: 2,
                child: Center(child: Text(plant.name, style: Theme.of(context).textTheme.headline, textAlign: TextAlign.center,)),
              ),
              // The plant next wattering
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.tint),
                    Text(TimelineHelper.instance.remainingDaysString(plant), style: Theme.of(context).textTheme.subhead,)
                  ],
                ),
              ),
              // The plant detail button
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor)),
                    onPressed: () {
                      print("Details button pressed");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                          value: plant,
                          child: PlantDetailsPage(),
                        )),
                      );
                    },
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