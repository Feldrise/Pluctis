import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/Dialogs/Plants/PlantLimitReachedDialog.dart';
import 'package:pluctis/Helpers/InAppPurchaseHelper.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Widgets/Plants/PlantGridItem.dart';
import 'package:pluctis/Widgets/PluctisTitle.dart';
import 'package:provider/provider.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  PlantsPageState createState() => PlantsPageState();
}

class PlantsPageState extends State<PlantsPage> {

  // Get the number of columns to show depending on screen size
  int get crossAxisCount {
    double width = MediaQuery.of(context).size.width;

    if (width > 800) {
      return 4;
    }
    else if (width > 600) {
      return 3;
    }

    return 2;
  }

  int get crossAxisTileCount {
    double width = MediaQuery.of(context).size.width;

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
            // padding: EdgeInsets.only(left: 8, right: 8),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/background.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PluctisTitle(title: "Plantes"),
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
                        Text("Vous n'avez pas de plante pour le moment. Appuyer sur \"+\" pour en ajouter.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subhead,) 
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: plants.allPlants.isNotEmpty,
                  child: Expanded(
                    child: StaggeredGridView.countBuilder(
                      scrollDirection: Axis.vertical,
                      // primary: false,
                      crossAxisCount: crossAxisCount,
                      itemCount: plants.allPlants.length,
                      itemBuilder: (context, index) {
                        var plant = plants.allPlants[index];
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
            )
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "plants_button",
            tooltip: "Editer",
            child: Icon(Icons.add, color: Colors.white,),
            onPressed: () async {
              await _addPlant(plants.allPlants.length);
            },

          ),
        );
      }
    );
  }
}