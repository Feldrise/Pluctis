import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pluctis/Dialogs/SuggestPlantDialog.dart';
import 'package:pluctis/Helpers/InAppPurchaseHelper.dart';
import 'package:pluctis/Models/ApplicationSettings.dart';
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
          body: Container(
            padding: EdgeInsets.only(bottom: 64, left: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Parametres", style: Theme.of(context).textTheme.title,),
                Card(
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Suggest plant 
                        RaisedButton(
                          child: Text("Vous ne trouvez pas votre plante ?"),
                          color: Theme.of(context).primaryColor.withAlpha(150), 
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext buildContext) => SuggestPlantDialog(scaffoldContext: context,),
                            );
                          },
                        ),

                        // Change notifcation time
                        RaisedButton(
                          child: Text("Heure de notification : ${applicationSettings.notificationHour}:${applicationSettings.notificationMinute}"),
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
                        ),

                        // Update brightness
                        RaisedButton(
                          child: Text(applicationSettings.isDark ? "Activer le mode claire" : "Activer me mode sombre"),
                          color: Theme.of(context).primaryColor.withAlpha(150),
                          onPressed: () async {
                            await applicationSettings.toggleBrightness();
                          },
                        ),
                        
                        // Change accent color
                        RaisedButton(
                          child: Text("Changer la couleur d'accent", style: TextStyle(color: Colors.white),),
                          color: Theme.of(context).accentColor,
                          onPressed: () async {
                            showDialog(
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
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          },
                        ),

                        SizedBox(height: 32,),

                        // Remove ads button
                        RaisedButton(
                          child: Text("Retirer les pubs"),
                          onPressed: () async {
                            InAppPurchaseHelper helper = InAppPurchaseHelper.instance;
                            bool isPremium = await helper.isPremium();

                            if (!isPremium) {
                              helper.buyPremium();
                            }
                          },
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        );
      },
    );
  }
}