import 'package:flutter/material.dart';
import 'package:pluctis/dialogs/plants/remove_plant_dialog.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/models/vegetables_list.dart';
import 'package:pluctis/pages/vege_garden/vege_identity_column.dart';
import 'package:pluctis/pages/vege_garden/vege_info_column.dart';
import 'package:pluctis/pages/vege_garden/vege_issues_column.dart';
import 'package:provider/provider.dart';

enum VegeDetailsTabItem { identity, information, issues }

Map<VegeDetailsTabItem, String> plantDetailsTabName = {
  VegeDetailsTabItem.identity: "Identité",
  VegeDetailsTabItem.information: "Informations",
  VegeDetailsTabItem.issues: "Problèmes",
};

Map<VegeDetailsTabItem, int> plantDetailsTabIndex = {
  VegeDetailsTabItem.identity: 0,
  VegeDetailsTabItem.information: 1,
  VegeDetailsTabItem.issues: 2,
};


class VegeDetailsPage extends StatefulWidget {
  const VegeDetailsPage({Key key, this.isAddingVegetable = false}) : super(key: key);
  
  final bool isAddingVegetable;

  @override
  _VegeDetailsPageState createState() => _VegeDetailsPageState();
}

class _VegeDetailsPageState extends State<VegeDetailsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  
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

        return true;
      },
      child: Consumer<Vegetable>(
        builder: (context, plant, child) {
          return Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  _buildItem(VegeDetailsTabItem.identity),
                  _buildItem(VegeDetailsTabItem.information),
                  _buildItem(VegeDetailsTabItem.issues),
                ],
              ),
              title: Container(),
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                VegeIdentityColumn(),
                VegeInfoColumn(),
                VegeIssuesColumn(),
              ],
            ),
            floatingActionButton: _floatingButton(plant),
          );
        },
      ),
    );
  }

  Tab _buildItem(VegeDetailsTabItem item) {
    return Tab(child: Text(plantDetailsTabName[item], style: TextStyle(color: Theme.of(context).accentColor),));
  }

  Widget _floatingButton(Vegetable vegetable) {
    if (widget.isAddingVegetable) {
      return FloatingActionButton(
        tooltip: "Valider",
        backgroundColor: Colors.green,
        onPressed: () async {
          // We show an ad, with 1/2 chances to appear
          final AdsHelper adsHelper = AdsHelper.instance;
          await adsHelper.showInterstitialAd(chanceToShow: 2);

          Navigator.of(context).pop(true);
        },
        child: const Icon(Icons.check, color: Colors.white,),
      );
    }

    return FloatingActionButton(
      tooltip: "Supprimer",
      backgroundColor: Colors.red,
      onPressed: () async {
        await _removeVegetable(vegetable);
      },
      child: const Icon(Icons.delete, color: Colors.white,),
      
    );
  }

  Future _removeVegetable(Vegetable vegetable) async {
    final bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) => RemovePlantDialog(),
    );

    if (delete != null && delete) {
      await Provider.of<VegetablesList>(context, listen: false).removeVegetable(vegetable);
      
      // We show an ad, with 1/3 chances to appear
      final AdsHelper adsHelper = AdsHelper.instance;
      await adsHelper.showInterstitialAd(chanceToShow: 3);

      Navigator.of(context).pop();
    }
  }
}