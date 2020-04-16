import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/AdsHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Widgets/Plants/PlantIdentityForm.dart';
import 'package:provider/provider.dart';

class AddPlantPage extends StatefulWidget {
  AddPlantPageState createState() => AddPlantPageState();
}

class AddPlantPageState extends State<AddPlantPage> {
  final _editIdentityFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // We show an ad, with 1/2 chances to appear
        AdsHelper adsHelper = AdsHelper.instance;
        await adsHelper.showInterstitialAd(chanceToShow: 2);

        return true;
      },
      child: Consumer<Plant>(
        builder: (context, plant, child) {
          return Scaffold(
            appBar: AppBar(
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
              child: PlantIdentityForm(formKey: _editIdentityFormKey,),
            ),
            floatingActionButton: Container(
              padding: EdgeInsets.only(bottom: 64),
              child: FloatingActionButton(
                tooltip: "Sauvegarder",
                child: Icon(Icons.check, color: Colors.white,),
                onPressed: () async {
                  print("Save plant pressed");
                  _editIdentityFormKey.currentState.save();

                  // We show an ad, with 1/2 chances to appear
                  AdsHelper adsHelper = AdsHelper.instance;
                  await adsHelper.showInterstitialAd(chanceToShow: 2);
                  
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}