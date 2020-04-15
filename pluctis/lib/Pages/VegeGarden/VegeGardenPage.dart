import 'package:flutter/material.dart';

class VegeGardenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 64, left: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Potager", style: Theme.of(context).textTheme.title,),
            Expanded(
              child: Center(
                child: Text("Le potager n'est pas encore disponible.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline,) 
              ),
            ) 
          ],
        ),
      ),
    );
  }
}