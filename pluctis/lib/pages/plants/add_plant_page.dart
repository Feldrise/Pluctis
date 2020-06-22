import 'package:flutter/material.dart';
import 'package:pluctis/helpers/ads_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/widgets/plants/plant_identity_form.dart';
import 'package:provider/provider.dart';

class AddPlantPage extends StatefulWidget {
  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _editIdentityFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // We show an ad, with 1/2 chances to appear
        final AdsHelper adsHelper = AdsHelper.instance;
        await adsHelper.showInterstitialAd(chanceToShow: 2);

        return true;
      },
      child: Consumer<Plant>(
        builder: (context, plant, child) {
          return Scaffold(
            appBar: AppBar(
              title: Container(),
            ),
            body: PlantIdentityForm(formKey: _editIdentityFormKey,),
            floatingActionButton: FloatingActionButton(
              tooltip: "Sauvegarder",
              onPressed: () async {
                _editIdentityFormKey.currentState.save();

                // We show an ad, with 1/2 chances to appear
                final AdsHelper adsHelper = AdsHelper.instance;
                await adsHelper.showInterstitialAd(chanceToShow: 2);
                
                Navigator.of(context).pop(true);
              },
              child: const Icon(Icons.check, color: Colors.white,),
            ),
          );
        },
      ),
    );
  }
}