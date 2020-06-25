import 'package:flutter/material.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/widgets/plants/plant_dashboard_widget.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

class DashboardCarousel extends StatefulWidget {
  const DashboardCarousel({Key key, @required this.allPlants}) : super(key: key);

  final List<Plant> allPlants;

  @override
  _DashboardCarouselState createState() => _DashboardCarouselState();
}

class _DashboardCarouselState extends State<DashboardCarousel> {
  PageController _pageController;
  int initialPage = 1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage
    );
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.allPlants.length,
        itemBuilder: (context, index) => buildDashboardSlider(index)
      ),
    );
  }

  Widget buildDashboardSlider(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0;

        if (_pageController.position.haveDimensions) {
          value = index - _pageController.page;
          value = (value * 0.038).clamp(-1, 1).toDouble();
        }
        return Transform.rotate(
          angle: math.pi * value,
          child: ChangeNotifierProvider.value(
            value: widget.allPlants[index],
            child: PlantDashboardWidget(),
          )
        );
      },
    );
  }

}