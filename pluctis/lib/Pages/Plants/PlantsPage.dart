import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Widgets/Plants/PlantGridItem.dart';
import 'package:provider/provider.dart';

class PlantsPage extends StatefulWidget {
  PlantsPageState createState() => PlantsPageState();
}

class PlantsPageState extends State<PlantsPage> {

  // Get the number of columns to show depending on screen size
  int _numberOfColumns() {
    double width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return 6;
    }
    else if (width > 1000) {
      return 5;
    }
    else if (width > 800) {
      return 4;
    }
    else if (width > 600) {
      return 3;
    }

    return 2;
  }

  @override
  void initState() {
    super.initState();

    Plant plant1 = Plant(
      slug: "plant1",
      name: "Plant 1",
      currentLocation: "Lieu 1",
      winterCycle: 1,
      springCycle: 2,
      summerCycle: 3,
      autumnCycle: 4
    );

    Plant plant2 = Plant(
      slug: "plant2",
      name: "Plant 2",
      currentLocation: "Lieu 2",
      winterCycle: 5,
      springCycle: 6,
      summerCycle: 7,
      autumnCycle: 8
    );

    Plant plant3 = Plant(
      slug: "plant3",
      name: "Plant 3",
      currentLocation: "Lieu 3",
      winterCycle: 9,
      springCycle: 1,
      summerCycle: 2,
      autumnCycle: 3
    );

    Provider.of<PlantsList>(context, listen: false).addPlant(plant1);
    Provider.of<PlantsList>(context, listen: false).addPlant(plant2);
    Provider.of<PlantsList>(context, listen: false).addPlant(plant3);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsList>(
      builder: (context, plants, child) {
        return Scaffold(
          appBar: AppBar(
            title: Container()
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 72, left: 8, right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Plantes", style: Theme.of(context).textTheme.title, textAlign: TextAlign.left,),
                Expanded(
                  child: GridView.builder(
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: _numberOfColumns(),
                      childAspectRatio: 2/3,
                    ),
                    itemCount: plants.allPlants.length,
                    itemBuilder: (context, index) {
                      var plant = plants.allPlants[index];
                      return ChangeNotifierProvider.value(
                        value: plant,
                        child: PlantGridItem(),
                      );
                    },
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }
}