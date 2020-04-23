import 'package:flutter/material.dart';
import 'package:pluctis/Dialogs/Plants/RemovePlantDialog.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Models/VegetablesList.dart';
import 'package:pluctis/Pages/VegeGarden/VegeIdentityColumn.dart';
import 'package:pluctis/Pages/VegeGarden/VegeInfoColumn.dart';
import 'package:pluctis/Pages/VegeGarden/VegeIssuesColumn.dart';
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
  
  final isAddingVegetable;

  VegeDetailsPageState createState() => VegeDetailsPageState();
}

class VegeDetailsPageState extends State<VegeDetailsPage> with SingleTickerProviderStateMixin {
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
    return WillPopScope(
      onWillPop: () async {
        // We show an ad, with 1/3 chances to appear
        AdsHelper adsHelper = AdsHelper.instance;
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
            body: Container(
              // padding: EdgeInsets.only(bottom: 72, left: 8, right: 8),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/background.png"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  VegeIdentityColumn(),
                  VegeInfoColumn(),
                  VegeIssuesColumn(),
                ],
              ),
            ),
            floatingActionButton: _floatingButton(plant),
          );
        },
      ),
    );
  }

  _buildItem(VegeDetailsTabItem item) {
    return Tab(child: Text(plantDetailsTabName[item], style: TextStyle(color: Theme.of(context).accentColor),));
  }

  Widget _floatingButton(Vegetable vegetable) {
    if (widget.isAddingVegetable) {
      return FloatingActionButton(
        tooltip: "Valider",
        backgroundColor: Colors.green,
        child: Icon(Icons.check, color: Colors.white,),
        onPressed: () async {
          print("Valide vegetable presseed");

          // We show an ad, with 1/2 chances to appear
          AdsHelper adsHelper = AdsHelper.instance;
          await adsHelper.showInterstitialAd(chanceToShow: 2);

          Navigator.of(context).pop(true);
        },
      );
    }

    return FloatingActionButton(
      tooltip: "Supprimer",
      backgroundColor: Colors.red,
      child: Icon(Icons.delete, color: Colors.white,),
      onPressed: () async {
        print("Delete vegetable presseed");
        await _removeVegetable(vegetable);
      },
      
    );
  }

  Future _removeVegetable(Vegetable vegetable) async {
    bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) => RemovePlantDialog(),
    );

    if (delete != null && delete) {
      await Provider.of<VegetablesList>(context, listen: false).removeVegetable(vegetable);
      
      // We show an ad, with 1/3 chances to appear
      AdsHelper adsHelper = AdsHelper.instance;
      await adsHelper.showInterstitialAd(chanceToShow: 3);

      Navigator.of(context).pop();
    }
  }
}