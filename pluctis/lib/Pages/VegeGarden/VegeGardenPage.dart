import 'package:flutter/material.dart';
import 'package:pluctis/Models/VegetablesList.dart';
import 'package:pluctis/Widgets/VegeGarden/VegetableListItem.dart';
import 'package:provider/provider.dart';

class VegeGardenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VegetablesList>(
      builder: (context, vegetables, child) {
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
                Text("Potager", style: Theme.of(context).textTheme.title,),
                Expanded(
                  child: ListView.builder(
                    itemCount: vegetables.allVegetables.length,
                    itemBuilder: (context, index) {
                      var vegetable = vegetables.allVegetables[index];
                      return ChangeNotifierProvider.value(
                        value: vegetable,
                        child: VegetableListItem(),
                      );
                    }, 
                  ),
                ) 
              ],
            ),
          ),
        );
      },
    );
  }
}