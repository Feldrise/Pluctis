import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:provider/provider.dart';

enum PlantDetailsTabItem { identity, information, disease }

Map<PlantDetailsTabItem, String> plantDetailsTabName = {
  PlantDetailsTabItem.identity: "Identité",
  PlantDetailsTabItem.information: "Informations",
  PlantDetailsTabItem.disease: "Maladies",
};

Map<PlantDetailsTabItem, int> plantDetailsTabIndex = {
    PlantDetailsTabItem.identity: 0,
  PlantDetailsTabItem.information: 1,
  PlantDetailsTabItem.disease: 2,
};


class PlantDetailsPage extends StatefulWidget {
  PlantDetailsPageState createState() => PlantDetailsPageState();
}

class PlantDetailsPageState extends State<PlantDetailsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  void _tabChanged() {
    setState(() {
      // Empty, we simply notify that we need to change the button  
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _tabController.addListener(_tabChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                _buildItem(PlantDetailsTabItem.identity),
                _buildItem(PlantDetailsTabItem.information),
                _buildItem(PlantDetailsTabItem.disease),
              ],
            ),
            title: Container(),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 72, left: 8, right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Center(child: Text(plant.name),),
                Center(child: Text("Infos"),),
                Center(child: Text("Maladies"),)
              ],
            ),
          ),
        );
      },
    );
  }

  _buildItem(PlantDetailsTabItem item) {
    return Tab(text: plantDetailsTabName[item],);
  }
}