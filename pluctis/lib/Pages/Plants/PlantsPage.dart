import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:pluctis/Dialogs/Plants/PlantLimitReachedDialog.dart';
import 'package:pluctis/Helpers/InAppPurchaseHelper.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Widgets/Plants/PlantGridItem.dart';
import 'package:provider/provider.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  PlantsPageState createState() => PlantsPageState();
}

class PlantsPageState extends State<PlantsPage> {

  // Get the number of columns to show depending on screen size
  int _numberOfColumns() {
    double width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return 6;
    }
    else if (width > 1000) {
      return 5;
    }
    else if (width > 800) {
      return 4;
    }
    else if (width > 600) {
      return 3;
    }

    return 2;
  }

  @override
  void initState() {
    super.initState();

    Provider.of<PlantsList>(context, listen: false).loadFromDatabase();
  }

  Future _addPlant(int plantCount) async {
    InAppPurchaseHelper inAppPurchaseHelper = InAppPurchaseHelper.instance;

    bool isPremium = await inAppPurchaseHelper.isPremium();

    if (plantCount >= 5 && !isPremium) {
      String addPlantAction = await showDialog(
        context: context,
        builder: (BuildContext context) => PlantLimitReachedDialog()
      );

      if (addPlantAction == null || (addPlantAction != "purchase_premium" && addPlantAction != "view_ad")) {
        return;
      }

      if (addPlantAction == "purchase_premium") {
        inAppPurchaseHelper.buyPremium();
        return;
      }

      if (addPlantAction == "view_ad") {
        AdsHelper.instance.showRewardAd((RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            widget.onPush('addPlantFindPage');
          }
        });

        return;
      }
    }
    
    widget.onPush('addPlantFindPage');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsList>(
      builder: (context, plants, child) {
        return Scaffold(
          appBar: AppBar(
            title: Container()
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 72, left: 8, right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Plantes", style: Theme.of(context).textTheme.title, textAlign: TextAlign.left,),
                Visibility(
                  child: Expanded(
                    child: Center(
                      child: Text("Vous n'avez aucune fleur d'intérieur pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline,) 
                    ),
                  ),
                  visible: plants.allPlants.isEmpty,
                ),
                Expanded(
                  child: GridView.builder(
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: _numberOfColumns(),
                      childAspectRatio: 2/3,
                    ),
                    itemCount: plants.allPlants.length,
                    itemBuilder: (context, index) {
                      var plant = plants.allPlants[index];
                      return ChangeNotifierProvider.value(
                        value: plant,
                        child: PlantGridItem(onPush: widget.onPush,),
                      );
                    },
                  ),
                )
              ],
            )
          ),
          floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 64),
            child: FloatingActionButton(
              tooltip: "Editer",
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: () async {
                await _addPlant(plants.allPlants.length);
              },
            ),
          ),
        );
      }
    );
  }
}