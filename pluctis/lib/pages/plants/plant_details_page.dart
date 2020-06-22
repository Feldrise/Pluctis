import 'package:flutter/material.dart';
import 'package:pluctis/dialogs/plants/remove_plant_dialog.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/pages/plants/plant_health_column.dart';
import 'package:pluctis/pages/plants/plant_identity_column.dart';
import 'package:pluctis/pages/plants/plant_info_column.dart';
import 'package:pluctis/widgets/plants/plant_identity_form.dart';
import 'package:provider/provider.dart';

enum PlantDetailsTabItem { identity, information, health }

Map<PlantDetailsTabItem, String> plantDetailsTabName = {
  PlantDetailsTabItem.identity: "Identité",
  PlantDetailsTabItem.information: "Informations",
  PlantDetailsTabItem.health: "Santé",
};

Map<PlantDetailsTabItem, int> plantDetailsTabIndex = {
  PlantDetailsTabItem.identity: 0,
  PlantDetailsTabItem.information: 1,
  PlantDetailsTabItem.health: 2,
};


class PlantDetailsPage extends StatefulWidget {
  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> with SingleTickerProviderStateMixin {
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

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_tabChanged);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // We show an ad, with 1/3 chances to appear
        final AdsHelper adsHelper = AdsHelper.instance;
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
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                if (_isEditing) PlantIdentityForm(formKey: _editIdentityFormKey,) else PlantIdentityColumn(),
                PlantInfoColumn(),
                PlantHealthColumn(),
              ],
            ),
            floatingActionButton: _floatingButton(plant),
          );
        },
      ),
    );
  }

  Tab _buildItem(PlantDetailsTabItem item) {
    return Tab(child: Text(plantDetailsTabName[item], style: TextStyle(color: Theme.of(context).accentColor)),);
  }

  Widget _floatingButton(Plant plant) {
    if (_tabController.index == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: "Supprimer",
            backgroundColor: Colors.red,
            onPressed: () async {
              await _removePlant(plant);
            },
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
          const SizedBox(width: 8,),
          FloatingActionButton(
            tooltip: "Editer",
            onPressed: () async {
              if (_isEditing) {
                _editIdentityFormKey.currentState.save();
                await plant.updateDatabase();

                // We show an ad, with 1/3 chances to appear
                final AdsHelper adsHelper = AdsHelper.instance;
                await adsHelper.showInterstitialAd(chanceToShow: 3);
              }

              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white,),
          ),
        ],
      );
    }

    return FloatingActionButton(
      tooltip: "Supprimer",
      backgroundColor: Colors.red,
      onPressed: () async {
        await _removePlant(plant);
      },
      child: const Icon(Icons.delete, color: Colors.white,),
    );
  }

  Future _removePlant(Plant plant) async {
    final bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) => RemovePlantDialog(),
    );

    if (delete != null && delete) {
      await Provider.of<PlantsList>(context, listen: false).removePlant(plant);
      
      // We show an ad, with 1/3 chances to appear
      final AdsHelper adsHelper = AdsHelper.instance;
      await adsHelper.showInterstitialAd(chanceToShow: 3);

      Navigator.of(context).pop();
    }
  }
}