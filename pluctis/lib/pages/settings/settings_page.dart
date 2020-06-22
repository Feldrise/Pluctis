import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pluctis/dialogs/suggest_plant_dialog.dart';
import 'package:pluctis/helpers/in_app_purchase_helper.dart';
import 'package:pluctis/models/application_settings.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationSettings>(
      builder: (context, applicationSettings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Container(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[ 
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const PluctisTitle(title: "Paramètres"),
                      PluctisCard(
                        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // Suggest plant 
                            RaisedButton(
                              color: Theme.of(context).primaryColor.withAlpha(150), 
                              onPressed: () async {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext buildContext) => SuggestPlantDialog(scaffoldContext: context,),
                                );
                              },
                              child: const Text("Vous ne trouvez pas votre plante ?"),
                            ),

                            // Change notifcation time
                            RaisedButton(
                              color: Theme.of(context).primaryColor.withAlpha(150),
                              onPressed: () async {
                                final TimeOfDay picked = await showTimePicker(
                                  context: context,
                                  initialTime: applicationSettings.notificationTime
                                );

                                if (picked != null) {
                                  await applicationSettings.updateNotificationTime(picked);
                                }
                              },
                              child: Text("Heure de notification : ${applicationSettings.notificationHour}:${applicationSettings.notificationMinute}"),
                            ),

                            // Update brightness
                            RaisedButton(
                              color: Theme.of(context).primaryColor.withAlpha(150),
                              onPressed: () async {
                                await applicationSettings.toggleBrightness();
                              },
                              child: Text(applicationSettings.isDark ? "Activer le mode claire" : "Activer le mode sombre"),
                            ),
                            
                            // Change accent color
                            RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () async {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Choisissez une couleur'),
                                      content: SingleChildScrollView(
                                        child: MaterialPicker(
                                          pickerColor: applicationSettings.accentColor,
                                          onColorChanged: (newColor) async {
                                            await applicationSettings.changeAccentColor(newColor);
                                          },
                                          enableLabel: true,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              child: const Text("Changer la couleur d'accent", style: TextStyle(color: Colors.white),),
                            ),

                            const SizedBox(height: 32,),

                            // Remove ads button
                            FutureBuilder(
                              future: InAppPurchaseHelper.instance.isPremium(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data as bool) {
                                    return const Text("Vous êtes premium ! Merci beaucoup.", textAlign: TextAlign.center,);
                                  }
                                  else {
                                    return RaisedButton(
                                      onPressed: () async {
                                        final InAppPurchaseHelper helper = InAppPurchaseHelper.instance;
                                        final bool isPremium = await helper.isPremium();

                                        if (!isPremium) {
                                          helper.buyPremium();
                                        }
                                      },
                                      child: const Text("Retirer les pubs"),
                                    );
                                  }
                                }
                                else if(snapshot.hasError) {
                                  return Text("Nous n'arrivons pas à savoir si vous êtes premium...\n${snapshot.error}");
                                }

                                // By default, show a loading spinner.
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),

                            // Restore purchase button
                            RaisedButton(
                              onPressed: () async {
                                final InAppPurchaseHelper helper = InAppPurchaseHelper.instance;
                                final bool restored = await helper.loadPreviousPurchase();
                                
                                if (restored) {
                                  Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Votre achat a bien été restoré.", style: TextStyle(color: Colors.white)), backgroundColor: Color(0xff388e3c),));
                                }
                                else {
                                  Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("Votre achat ne peut pas être restoré...", style: TextStyle(color: Colors.white),), backgroundColor: Color(0xffd32f2f)));
                                }
                              },
                              child: const Text("Restorer un achat"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}