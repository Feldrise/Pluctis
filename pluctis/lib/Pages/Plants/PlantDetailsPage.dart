import 'package:flutter/material.dart';
import 'package:pluctis/Dialogs/Plants/RemovePlantDialog.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Pages/Plants/PlantHealthColumn.dart';
import 'package:pluctis/Pages/Plants/PlantIdentityColumn.dart';
import 'package:pluctis/Pages/Plants/PlantInfoColumn.dart';
import 'package:pluctis/Widgets/Plants/PlantIdentityForm.dart';
import 'package:provider/provider.dart';

enum PlantDetailsTabItem { identity, information, health }

Map<PlantDetailsTabItem, String> plantDetailsTabName = {
  PlantDetailsTabItem.identity: "Identité",
  PlantDetailsTabItem.information: "Informations",
  PlantDetailsTabItem.health: "Santée",
};

Map<PlantDetailsTabItem, int> plantDetailsTabIndex = {
  PlantDetailsTabItem.identity: 0,
  PlantDetailsTabItem.information: 1,
  PlantDetailsTabItem.health: 2,
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
    return WillPopScope(
      onWillPop: () async {
        // We show an ad, with 1/3 chances to appear
        AdsHelper adsHelper = AdsHelper.instance;
        await adsHelper.showInterstitialAd(chanceToShow: 3);

        if (_isEditing) {
          setState(() {
            _isEditing = false;
          });

          return false;
        }

        return true;
      },
      child: Consumer<Plant>(
        builder: (context, plant, child) {
          return Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  _buildItem(PlantDetailsTabItem.identity),
                  _buildItem(PlantDetailsTabItem.information),
                  _buildItem(PlantDetailsTabItem.health),
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
                  PlantHealthColumn(),
                ],
              ),
            ),
            floatingActionButton: _floatingButton(plant),
          );
        },
      ),
    );
  }

  _buildItem(PlantDetailsTabItem item) {
    return Tab(text: plantDetailsTabName[item],);
  }

  Widget _floatingButton(Plant plant) {
    if (_tabController.index == 0) {
      return Container(
        padding: EdgeInsets.only(bottom: 64),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              tooltip: "Supprimer",
              backgroundColor: Colors.red,
              child: Icon(Icons.delete, color: Colors.white,),
              onPressed: () async {
                print("Delete plant presseed");
                await _removePlant(plant);
              },
            ),
            SizedBox(width: 8,),
            FloatingActionButton(
              tooltip: "Editer",
              child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white,),
              onPressed: () async {
                print("Edit plant pressed");
                if (_isEditing) {
                  _editIdentityFormKey.currentState.save();
                  await plant.updateDatabase();

                  // We show an ad, with 1/3 chances to appear
                  AdsHelper adsHelper = AdsHelper.instance;
                  await adsHelper.showInterstitialAd(chanceToShow: 3);
                }

                setState(() {
                  _isEditing = !_isEditing;
                });
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: 64),
      child: FloatingActionButton(
        tooltip: "Supprimer",
        backgroundColor: Colors.red,
        child: Icon(Icons.delete, color: Colors.white,),
        onPressed: () async {
          print("Delete plant presseed");
          await _removePlant(plant);
        },
      ),
    );
  }

  Future _removePlant(Plant plant) async {
    bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) => RemovePlantDialog(),
    );

    if (delete != null && delete) {
      await Provider.of<PlantsList>(context, listen: false).removePlant(plant);
      
      // We show an ad, with 1/3 chances to appear
      AdsHelper adsHelper = AdsHelper.instance;
      await adsHelper.showInterstitialAd(chanceToShow: 3);

      Navigator.of(context).pop();
    }
  }
}