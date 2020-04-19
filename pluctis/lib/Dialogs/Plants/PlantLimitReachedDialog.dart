import 'package:flutter/material.dart';

class PlantLimitReachedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Nouvelle Plante"),
      content: Text("Vous avez atteind la limite de plantes. Si vous voulez en ajouter plus, vous pouvez regarder une publicité où acheter la version premium de Pluctis"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop("purchase_premium");
          },
          child: Text("Premium", style: TextStyle(color: Theme.of(context).accentColor,)),
        ),
        FlatButton(
          onPressed: ()  {
            Navigator.of(context).pop("view_ad");
          },
          child: Text("Vidéo", style: TextStyle(color: Theme.of(context).accentColor,)),
        )
      ],
    );
  }
}