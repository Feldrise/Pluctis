import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Widgets/Plants/PlantDashboardWidget.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  final List<Plant> _unhappyPlant = [];
  final List<Plant> _nextPlant = [];
  final List<Plant> _happyPlant = [];

  void _sortPlants(List<Plant> allPlants) {
    _unhappyPlant.clear();
    _nextPlant.clear();
    _happyPlant.clear();

    _unhappyPlant.clear();
    _nextPlant.clear();
    _happyPlant.clear();

    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);

    for (var plant in allPlants) {
      // if (plant.isAlive != null && !plant.isAlive) {
      //   continue;
      // }

      Duration remaining = plant.nextWatering.difference(now);

      // The plant is un happy means it has not been watered
      if (remaining.inDays < 0) {
        _unhappyPlant.add(plant);
      }
      else if (remaining.inDays == 0 || remaining.inDays == 1) {
        _nextPlant.add(plant);
      }
      else {
        _happyPlant.add(plant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsList>(
      builder: (context, plants, child) {
        _sortPlants(plants.allPlants);

        if (_unhappyPlant.isEmpty && _nextPlant.isEmpty && _happyPlant.isEmpty) {
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
                  Text("Tableau de Bord", style: Theme.of(context).textTheme.title,),
                  Expanded(
                    child: Center(
                      child: Text("Aucune fleur ne nécessite d'action pour le moment.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline,) 
                    ),
                  ) 
                ],
              ),
            ),
          );
        }

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tableau de bord", style: Theme.of(context).textTheme.title,),

                  // The plants who really need watering
                  Visibility(
                    visible: _unhappyPlant.isNotEmpty,
                    child: SizedBox(
                      height: 258,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          margin: EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: _unhappyPlant.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return SvgPicture.asset(
                                    'assets/svg/crying.svg',
                                    semanticsLabel: "Icon",
                                    height: 112,
                                  );
                                }

                                return ChangeNotifierProvider.value(
                                  value: _unhappyPlant[index - 1],
                                  child: PlantDashboardWidget(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // END: The plants who really need watering

                  // The plants who will need watering
                  Visibility(
                    visible: _nextPlant.isNotEmpty,
                    child: SizedBox(
                      height: 258,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          margin: EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: _nextPlant.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return SvgPicture.asset(
                                    'assets/svg/water_cycle.svg',
                                    semanticsLabel: "Icon",
                                    height: 112,
                                  );
                                }

                                return ChangeNotifierProvider.value(
                                  value: _nextPlant[index - 1],
                                  child: PlantDashboardWidget(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // END: The plants who really need watering

                  // The plants who will need watering
                  Visibility(
                    visible: _happyPlant.isNotEmpty,
                    child: SizedBox(
                      height: 258,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          margin: EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: _happyPlant.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return SvgPicture.asset(
                                    'assets/svg/spring.svg',
                                    semanticsLabel: "Icon",
                                    height: 112,
                                  );
                                }

                                return ChangeNotifierProvider.value(
                                  value: _happyPlant[index - 1],
                                  child: PlantDashboardWidget(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // END: The plants who really need watering


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}