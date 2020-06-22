import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/dialogs/plants/plant_limit_reached_dialog.dart';
import 'package:pluctis/helpers/in_app_purchase_helper.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/widgets/plants/plant_grid_item.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  @override
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {

  // Get the number of columns to show depending on screen size
  int get crossAxisCount {
    final double width = MediaQuery.of(context).size.width;

    if (width > 800) {
      return 4;
    }
    else if (width > 600) {
      return 3;
    }

    return 2;
  }

  int get crossAxisTileCount {
    final double width = MediaQuery.of(context).size.width;

    if (width > 800) {
      return 1;
    }
    else if (width > 600) {
      return 1;
    }

    return 1;
  }

  @override
  void initState() {
    super.initState();

    Provider.of<PlantsList>(context, listen: false).loadFromDatabase();
  }

  Future _addPlant(int plantCount) async {
    final InAppPurchaseHelper inAppPurchaseHelper = InAppPurchaseHelper.instance;

    final bool isPremium = await inAppPurchaseHelper.isPremium();

    if (plantCount >= 5 && !isPremium) {
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PluctisTitle(title: "Plantes"),
              Visibility(
                visible: plants.allPlants.isEmpty,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svg/spring.svg',
                        semanticsLabel: "Icon",
                        height: 92,
                      ),
                      Text("Vous n'avez pas de plante pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1,) 
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: plants.allPlants.isNotEmpty,
                child: Expanded(
                  child: StaggeredGridView.countBuilder(
                    // primary: false,
                    crossAxisCount: crossAxisCount,
                    itemCount: plants.allPlants.length,
                    itemBuilder: (context, index) {
                      final plant = plants.allPlants[index];
                      return ChangeNotifierProvider.value(
                        value: plant,
                        child: PlantGridItem(onPush: widget.onPush,),
                      );
                    },
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.extent(crossAxisTileCount, index.isEven ? 264 : 328);
                    },
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                )
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "plants_button",
            tooltip: "Editer",
            onPressed: () async {
              await _addPlant(plants.allPlants.length);
            },
            child: const Icon(Icons.add, color: Colors.white,),

          ),
        );
      }
    );
  }
}