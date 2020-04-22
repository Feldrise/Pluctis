import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegeProblem.dart';
import 'package:pluctis/Pages/VegeGarden/VegeProblemDetail.dart';
import 'package:pluctis/Widgets/PluctisCard.dart';

class VegeProblemItem extends StatelessWidget {
  const VegeProblemItem({@required this.problem});

  final VegeProblem problem;

  @override
  Widget build(BuildContext context) {
    return PluctisCard(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Image(
                image: AssetImage("assets/images/vege_problems/${problem.slug}.png"),
                fit: BoxFit.fitHeight,
                height: 124,
                width: 92,
              ),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: 124,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(problem.name, style: Theme.of(context).textTheme.headline),
                  ),
                  FlatButton(
                      child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor,)),
                      onPressed: () {
                        print("Vegetable probleme detail pressed");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VegeProblemDetail(problem: problem,))
                        );
                      },
                    ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}