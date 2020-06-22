import 'package:flutter/material.dart';
import 'package:pluctis/models/vege_problem.dart';
import 'package:pluctis/pages/vege_garden/vege_problem_detail.dart';
import 'package:pluctis/widgets/pluctis_card.dart';

class VegeProblemItem extends StatelessWidget {
  const VegeProblemItem({@required this.problem});

  final VegeProblem problem;

  @override
  Widget build(BuildContext context) {
    return PluctisCard(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Image(
                image: AssetImage("assets/images/vege_problems/${problem.slug}.png"),
                fit: BoxFit.fitHeight,
                height: 124,
                width: 92,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 124,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(problem.name, style: Theme.of(context).textTheme.headline5),
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(builder: (context) => VegeProblemDetail(problem: problem,))
                        );
                      },
                      child: Text("Détails", style: TextStyle(color: Theme.of(context).accentColor,)),
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