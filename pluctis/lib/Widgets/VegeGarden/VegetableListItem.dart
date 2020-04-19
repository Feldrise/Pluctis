import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/TimelineHelper.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Pages/VegeGarden/VegeDetailsPage.dart';
import 'package:provider/provider.dart';

class VegetableListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 8.0,
          ),
          child: Stack(
            children: <Widget>[
              vegetableCard(context, vegetable),
              vegetableThumbail(vegetable)
            ],
          ),
        );
      },
    );
  }

  Widget vegetableCard(BuildContext context, Vegetable vegetable) {
    return Card(
      margin: EdgeInsets.only(left: 46),
      child: Container(
        padding: EdgeInsets.only(left: 62, top: 16, bottom: 0, right: 8),
        height: 144,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(vegetable.name, style: Theme.of(context).textTheme.headline,),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.history),
                SizedBox(width: 4,),
                Expanded(
                  flex: 8,
                  child: Text(" • Actuellement : ${vegetable.currentState}\n • Prochaine étape : ${TimelineHelper.instance.vegetableNextState(vegetable)}"),
                )
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FlatButton(
                  child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor),),
                  onPressed: () {
                    print("Vegetable details pressed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                        value: vegetable,
                        child: VegeDetailsPage(),
                      )),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget vegetableThumbail(Vegetable vegetable) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 26),
      alignment: FractionalOffset.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56),
        child: Image(
          image: AssetImage("assets/images/vegetables/${vegetable.slug}.png"),
          width: 92,
          height: 92,
        ),
      ),
    );
  }
}