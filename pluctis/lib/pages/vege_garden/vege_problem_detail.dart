import 'package:flutter/material.dart';
import 'package:pluctis/models/vege_problem.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';

class VegeProblemDetail extends StatelessWidget {
  const VegeProblemDetail({Key key, @required this.problem}) : super(key: key);
  
  final VegeProblem problem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: SingleChildScrollView( 
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PluctisTitle(title: problem.name),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PluctisCard(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Symptomes", style: Theme.of(context).textTheme.headline5,),
                      const SizedBox(height: 8,),
                      Text(problem.symptoms),
                    ],
                  ),
                ),
                PluctisCard(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Remède", style: Theme.of(context).textTheme.headline5,),
                      const SizedBox(height: 8,),
                      Text(problem.remedy),
                    ],
                  ),
                ),

                PluctisCard(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      // colorBlendMode: _plant.isAlive ? null : BlendMode.darken,
                      // color: _plant.isAlive ? null : Colors.black54,
                      // width: 25,
                      image: AssetImage("assets/images/vege_problems/${problem.slug}.png"), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32,)
              ],
            )
          ],
        ),
      ),
    );
  }
}