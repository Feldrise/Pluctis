import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:pluctis/Dialogs/Plants/PlantLimitReachedDialog.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Helpers/InAppPurchaseHelper.dart';
import 'package:pluctis/Models/VegetablesList.dart';
import 'package:pluctis/Widgets/VegeGarden/VegetableListItem.dart';
import 'package:provider/provider.dart';

class VegeGardenPage extends StatefulWidget {
  const VegeGardenPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  VegeGardenPageState createState() => VegeGardenPageState();
}

class VegeGardenPageState extends State<VegeGardenPage> {
  Future _addVegetable(int vegetableCount) async {
    InAppPurchaseHelper inAppPurchaseHelper = InAppPurchaseHelper.instance;

    bool isPremium = await inAppPurchaseHelper.isPremium();

    if (vegetableCount >= 10 && !isPremium) {
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
            widget.onPush('addVegetableFindPage');
          }
        });

        return;
      }
    }
    
    widget.onPush('addVegetableFindPage');
  }

  @override
  void initState() {
    super.initState();

    Provider.of<VegetablesList>(context, listen: false).loadFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VegetablesList>(
      builder: (context, vegetables, child) {
        return Scaffold(
          appBar: AppBar(
            title: Container(),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 64, left: 8, right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Potager", style: Theme.of(context).textTheme.title,),
                Visibility(
                  child: Expanded(
                    child: Center(
                      child: Text("Vous n'avez rien dans votre potager pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline,) 
                    ),
                  ),
                  visible: vegetables.allVegetables.isEmpty,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: vegetables.allVegetables.length,
                    itemBuilder: (context, index) {
                      var vegetable = vegetables.allVegetables[index];
                      return ChangeNotifierProvider.value(
                        value: vegetable,
                        child: VegetableListItem(),
                      );
                    }, 
                  ),
                ) 
              ],
            ),
          ),
          floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 64),
            child: FloatingActionButton(
              tooltip: "Ajouter",
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: () async {
                await _addVegetable(vegetables.allVegetables.length);
              },
            ),
          ),
        );
      },
    );
  }
}