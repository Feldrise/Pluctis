import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TabItem { dashboard, plants, vege_garden, settings }

Map<TabItem, String> tabName = {
  TabItem.dashboard: "Accueil",
  TabItem.plants: "Plantes",
  TabItem.vege_garden: "Potager",
  TabItem.settings: "Paramètres"
};

Map<TabItem, IconData> tabIcon = {
  TabItem.dashboard: FontAwesomeIcons.home,
  TabItem.plants: FontAwesomeIcons.seedling,
  TabItem.vege_garden: FontAwesomeIcons.carrot,
  TabItem.settings: FontAwesomeIcons.cog,
};

Map<TabItem, int> tabIndex = {
  TabItem.dashboard: 0,
  TabItem.plants: 1,
  TabItem.vege_garden: 2,
  TabItem.settings: 3,
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabIndex[currentTab],
          items: [
            _buildItem(context, tabItem: TabItem.dashboard),
            _buildItem(context, tabItem: TabItem.plants),
            _buildItem(context, tabItem: TabItem.vege_garden),
            _buildItem(context, tabItem: TabItem.settings)
          ],
          onTap: (index) => onSelectTab(
            TabItem.values[index],
          ),
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.grey,
          iconSize: 24,
          elevation: 0,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, {TabItem tabItem}) {
    String text = tabName[tabItem];
    IconData icon = tabIcon[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        icon
      ),
      title: Text(
        text
      ),
    );
  }
}