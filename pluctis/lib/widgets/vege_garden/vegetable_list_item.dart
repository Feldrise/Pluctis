import 'package:flutter/material.dart';
import 'package:pluctis/helpers/timeline_helper.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/pages/vege_garden/vege_details_page.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
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
    return PluctisCard(
      margin: const EdgeInsets.only(left: 46),
      child: Container(
        padding: const EdgeInsets.only(left: 62, top: 16, right: 8),
        height: 144,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(vegetable.name, style: Theme.of(context).textTheme.headline5,),
            const SizedBox(height: 8,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.history),
                const SizedBox(width: 4,),
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
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                        value: vegetable,
                        child: const VegeDetailsPage(),
                      )),
                    );
                  },
                  child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor),),
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
      margin: const EdgeInsets.symmetric(vertical: 26),
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