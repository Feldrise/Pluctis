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
    // Alternative bottom bar
    // return Container(
    //   margin: EdgeInsets.only(left: 8, right: 8),
    //   padding: EdgeInsets.only(top: 8, left: 16, right: 16),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).scaffoldBackgroundColor,
    //     border: Border.all(color: Theme.of(context).accentColor, width: 1),
    //     // border: Border(
    //     //   left: BorderSide(color: Theme.of(context).accentColor, width: 2),
    //     //   right: BorderSide(color: Theme.of(context).accentColor, width: 2),
    //     //   top: BorderSide(color: Theme.of(context).accentColor, width: 2),
    //     // ),
    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    //   ),
    //   child: BottomNavigationBar(
    //     type: BottomNavigationBarType.fixed,
    //     currentIndex: tabIndex[currentTab],
    //     items: [
    //       _buildItem(context, tabItem: TabItem.dashboard),
    //       _buildItem(context, tabItem: TabItem.plants),
    //       _buildItem(context, tabItem: TabItem.vege_garden),
    //       _buildItem(context, tabItem: TabItem.settings)
    //     ],
    //     onTap: (index) => onSelectTab(
    //       TabItem.values[index],
    //     ),
    //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //     selectedItemColor: Theme.of(context).accentColor,
    //     unselectedItemColor: Theme.of(context).accentColor.withAlpha(150),
    //     iconSize: 24,
    //     elevation: 0,
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).accentColor,
      ),
      margin: EdgeInsets.all(0),
      height: 72,
      child: Align(
        alignment: Alignment.bottomCenter,
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
          backgroundColor: Theme.of(context).accentColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
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