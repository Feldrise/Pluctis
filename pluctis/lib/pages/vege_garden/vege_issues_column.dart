import 'package:flutter/material.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:pluctis/widgets/vege_garden/vege_problem_item.dart';
import 'package:provider/provider.dart';

class VegeIssuesColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Vegetable>(
      builder: (context, vegetable, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Problèmes"),
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