import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/widgets/plants/plant_dashboard_carousel.dart';
import 'package:pluctis/widgets/plants/plant_dashboard_widget.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
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

    final DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10);

    for (final plant in allPlants) {
      // if (plant.isAlive != null && !plant.isAlive) {
      //   continue;
      // }

      final Duration remaining = plant.nextWatering.difference(now);

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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const PluctisTitle(title: "Tableau de Bord"),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svg/smiling.svg',
                        semanticsLabel: "Icon",
                        height: 92,
                      ),
                      Text("Aucune fleur de nécessite d'action pour le moment.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1,) 
                    ],
                  ),
                ) 
              ],
            ),
          );
        }

        final bool useOldDashboard = Provider.of<ApplicationSettings>(context).useOldDashboard;

        return Scaffold(
          appBar: AppBar(
            title: Container(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[ 
              const PluctisTitle(title: "Tableau de bord"),
              if (!useOldDashboard) DashboardCarousel(allPlants: _unhappyPlant + _nextPlant,) else Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // The plants who really need watering
                      Visibility(
                        visible: _unhappyPlant.isNotEmpty,
                        child: SizedBox(
                          height: 324,
                          child: Stack(
                            children: <Widget>[
                              PluctisCard(
                                margin: const EdgeInsets.only(top: 46, left: 8, right: 8, bottom: 16),
                                padding: const EdgeInsets.only(top: 46.0, left: 16.0, bottom: 8.0, right: 8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _unhappyPlant.length,
                                  itemBuilder: (context, index) {
                                    return ChangeNotifierProvider.value(
                                      value: _unhappyPlant[index],
                                      child: PlantDashboardWidget(),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/svg/crying.svg',
                                      semanticsLabel: "Icon",
                                      width: 92,
                                      height: 92,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // END: The plants who really need watering

                      // The plants who will need watering
                      Visibility(
                        visible: _nextPlant.isNotEmpty,
                        child: SizedBox(
                          height: 324,
                          child: Stack(
                            children: <Widget>[
                              PluctisCard(
                                margin: const EdgeInsets.only(top: 46, left: 8, right: 8, bottom: 16),
                                padding: const EdgeInsets.only(top: 46.0, left: 16.0, bottom: 8.0, right: 8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _nextPlant.length,
                                  itemBuilder: (context, index) {
                                    return ChangeNotifierProvider.value(
                                      value: _nextPlant[index],
                                      child: PlantDashboardWidget(),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/svg/water_cycle.svg',
                                      semanticsLabel: "Icon",
                                      width: 92,
                                      height: 92,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // END: The plants who will need watering


                      // The plants who are happy
                      Visibility(
                        visible: _happyPlant.isNotEmpty,
                        child: SizedBox(
                          height: 324,
                          child: Stack(
                            children: <Widget>[
                              PluctisCard(
                                margin: const EdgeInsets.only(top: 46, left: 8, right: 8, bottom: 16),
                                padding: const EdgeInsets.only(top: 46.0, left: 16.0, bottom: 8.0, right: 8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _happyPlant.length,
                                  itemBuilder: (context, index) {
                                    return ChangeNotifierProvider.value(
                                      value: _happyPlant[index],
                                      child: PlantDashboardWidget(),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/svg/smiling.svg',
                                      semanticsLabel: "Icon",
                                      width: 92,
                                      height: 92,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // END: The plants who are happy

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}