import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegeProblem.dart';

class VegeProblemDetail extends StatelessWidget {
  const VegeProblemDetail({Key key, @required this.problem}) : super(key: key);
  
  final VegeProblem problem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 64, left: 8, right: 8),
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
            Text(problem.name, style: Theme.of(context).textTheme.title,),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Symptomes", style: Theme.of(context).textTheme.headline,),
                          SizedBox(height: 8,),
                          Text(problem.symptoms),
                        ],
                      ),
                    )
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Remède", style: Theme.of(context).textTheme.headline,),
                          SizedBox(height: 8,),
                          Text(problem.remedy),
                        ],
                      ),
                    )
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        // colorBlendMode: _plant.isAlive ? null : BlendMode.darken,
                        // color: _plant.isAlive ? null : Colors.black54,
                        // width: 25,
                        image: AssetImage("assets/images/vege_problems/${problem.slug}.png"), 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 32,)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}