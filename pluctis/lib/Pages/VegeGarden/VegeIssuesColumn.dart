import 'package:flutter/material.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Widgets/VegeGarden/VegeProblemItem.dart';
import 'package:provider/provider.dart';

class VegeIssuesColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Problèmes", style: Theme.of(context).textTheme.title,),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: vegetable.problems.length,
                itemBuilder: (context, index) {
                  return VegeProblemItem(problem: vegetable.problems[index],);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}