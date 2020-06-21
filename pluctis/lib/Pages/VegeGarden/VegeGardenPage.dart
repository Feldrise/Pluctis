import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/Dialogs/Plants/PlantLimitReachedDialog.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Helpers/InAppPurchaseHelper.dart';
import 'package:pluctis/Models/VegetablesList.dart';
import 'package:pluctis/Widgets/PluctisTitle.dart';
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
            // padding: EdgeInsets.only(bottom: 64, left: 8, right: 8),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/background.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PluctisTitle(title: "Potager"),
                Visibility(
                  visible: vegetables.allVegetables.isEmpty,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svg/vegetables.svg',
                          semanticsLabel: "Icon",
                          height: 92,
                        ),
                        Text("Vous n'avez rien dans votre potager pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subhead,) 
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: vegetables.allVegetables.isNotEmpty,
                  child: Expanded(
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
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "vege_button",
            tooltip: "Ajouter",
            child: Icon(Icons.add, color: Colors.white,),
            onPressed: () async {
              await _addVegetable(vegetables.allVegetables.length);
            },
          ),
        );
      },
    );
  }
}