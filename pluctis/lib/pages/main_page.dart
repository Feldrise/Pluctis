import 'package:flutter/material.dart';
import 'package:pluctis/bottom_navigation.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/tab_navigator.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.dashboard: GlobalKey<NavigatorState>(),
    TabItem.plants: GlobalKey<NavigatorState>(),
    TabItem.vegeGarden: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  TabItem _currentTab = TabItem.dashboard;

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<ApplicationSettings>(context, listen: false).initSettings(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.dashboard) {
            // select 'main' tab
            _selectTab(TabItem.dashboard);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.dashboard),
          _buildOffstageNavigator(TabItem.plants),
          _buildOffstageNavigator(TabItem.vegeGarden),
          _buildOffstageNavigator(TabItem.settings),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}