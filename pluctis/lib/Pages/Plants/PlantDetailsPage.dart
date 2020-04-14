import 'package:flutter/material.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Pages/Plants/PlantIdentityColumn.dart';
import 'package:pluctis/Pages/Plants/PlantInfoColumn.dart';
import 'package:pluctis/Widgets/Plants/PlantIdentityForm.dart';
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
  
  bool _isEditing = false;

  final _editIdentityFormKey = GlobalKey<FormState>();

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
                _isEditing ? PlantIdentityForm(formKey: _editIdentityFormKey,) : PlantIdentityColumn(),
                PlantInfoColumn(),
                Center(child: Text("Maladies"),)
              ],
            ),
          ),
          floatingActionButton: _floatingButton(),
        );
      },
    );
  }

  _buildItem(PlantDetailsTabItem item) {
    return Tab(text: plantDetailsTabName[item],);
  }

  Widget _floatingButton() {
    if (_tabController.index == 0) {
      return Container(
        padding: EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
          tooltip: "Editer",
          child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white,),
          onPressed: () {
            print("Edit plant pressed");
            if (_isEditing) {
              _editIdentityFormKey.currentState.save();
            }

            setState(() {
              _isEditing = !_isEditing;
            });
          },
        ),
      );
    }

    return Container();
  }
}