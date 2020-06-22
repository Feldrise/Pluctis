import 'package:flutter/material.dart';
import 'package:pluctis/bottom_navigation.dart';
import 'package:pluctis/pages/dashboard_page.dart';
import 'package:pluctis/pages/plants/find_plant_page.dart';
import 'package:pluctis/pages/plants/plants_page.dart';
import 'package:pluctis/pages/settings/settings_page.dart';
import 'package:pluctis/pages/vege_garden/find_vegetable_page.dart';
import 'package:pluctis/pages/vege_garden/vege_garden_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String addPlantFindPage = "/addPlantFindPage";
  static const String addVegetableFindPage = "/addVegetableFindPage";
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({this.navigatorKey, this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {String destinationPage}) {
    final routeBuilders = _routeBuilders(context);

    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders['/$destinationPage'](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    // return {
    //   TabNavigatorRoutes.root: (context) => MorningPage(),
    //   TabNavigatorRoutes.morning: (context) => MorningPage(),
    //   TabNavigatorRoutes.reminders: (context) => RemindersPage(),
    //   TabNavigatorRoutes.tenWordsPage: (context) => TenWordsPage(),
    // };

    if (tabItem == TabItem.plants) {
      return {
        TabNavigatorRoutes.root: (context) => PlantsPage(
          onPush: (destinationPage) => _push(context, destinationPage: destinationPage),
        ),
        TabNavigatorRoutes.addPlantFindPage: (context) => FindPlantPage(),
      };
    }

    if (tabItem == TabItem.vegeGarden) {
      return {
        TabNavigatorRoutes.root: (context) => VegeGardenPage(
          onPush: (destinationPage) => _push(context, destinationPage: destinationPage),
        ),
        TabNavigatorRoutes.addVegetableFindPage: (context) => FindVegetablePage(),
      };
    }

    if (tabItem == TabItem.settings) {
      return {
        TabNavigatorRoutes.root: (context) => SettingsPage(),
      };
    }

    return {
      TabNavigatorRoutes.root: (context) => DashboardPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute<void>(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
