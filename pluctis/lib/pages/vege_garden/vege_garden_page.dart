import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/dialogs/plants/plant_limit_reached_dialog.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/helpers/in_app_purchase_helper.dart';
import 'package:pluctis/models/vegetables_list.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:pluctis/widgets/vege_garden/vegetable_list_item.dart';
import 'package:provider/provider.dart';

class VegeGardenPage extends StatefulWidget {
  const VegeGardenPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  @override
  _VegeGardenPageState createState() => _VegeGardenPageState();
}

class _VegeGardenPageState extends State<VegeGardenPage> {
  Future _addVegetable(int vegetableCount) async {
    final InAppPurchaseHelper inAppPurchaseHelper = InAppPurchaseHelper.instance;

    final bool isPremium = await inAppPurchaseHelper.isPremium();

    if (vegetableCount >= 10 && !isPremium) {
      final String addPlantAction = await showDialog(
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const PluctisTitle(title: "Potager"),
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
                      Text("Vous n'avez rien dans votre potager pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1,) 
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
                      final vegetable = vegetables.allVegetables[index];
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
          floatingActionButton: FloatingActionButton(
            heroTag: "vege_button",
            tooltip: "Ajouter",
            onPressed: () async {
              await _addVegetable(vegetables.allVegetables.length);
            },
            child: const Icon(Icons.add, color: Colors.white,),
          )
        );
      },
    );
  }
}