import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:provider/provider.dart';

class PlantIdentityForm extends StatelessWidget {
  const PlantIdentityForm({Key key, @required this.formKey}) : super(key: key);

  final formKey;
  
  @override
  Widget build(BuildContext context) {    
    return Consumer<Plant>(
      builder: (context, plant, child) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Identite", style: Theme.of(context).textTheme.title,),
                Card(
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/name.svg',
                            semanticsLabel: "Icon",
                            height: 32,
                          ),
                          title: TextFormField(
                            initialValue: plant.name,
                            decoration: InputDecoration(labelText: "Nom"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un nom à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setName(value),
                          ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/current_room.svg',
                            semanticsLabel: "Icon",
                            height: 32,
                          ),
                          title: TextFormField(
                            initialValue: plant.currentLocation,
                            decoration: InputDecoration(labelText: "Lieu"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un lieu à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setCurrentLocation(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/water_cycle.svg',
                            semanticsLabel: "Icon",
                            height: 32,
                          ),
                          title: Text("Cycle d'arrosage (Tous les X jours)"),
                          subtitle: Text("Si vous n'êtes pas sur, laissez les valeurs par défaut qui viennent de notre base de données."),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/winter.svg',
                            semanticsLabel: "Icon",
                            height: 24,
                          ),
                          title: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],
                            initialValue: '${plant.winterCycle}',
                            decoration: InputDecoration(labelText: "Hiver"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un cycle en hiver à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setSummerCycle(num.tryParse(value))
                          ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/spring.svg',
                            semanticsLabel: "Icon",
                            height: 24,
                          ),
                          title: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],
                            initialValue: '${plant.springCycle}',
                            decoration: InputDecoration(labelText: "Printemps"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un cycle au printemps à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setSpringCycle(num.tryParse(value))
                          ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/summer.svg',
                            semanticsLabel: "Icon",
                            height: 24,
                          ),
                          title: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],
                            initialValue: '${plant.summerCycle}',
                            decoration: InputDecoration(labelText: "Eté"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un cycle en été à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setSummerCycle(num.tryParse(value))
                          ),
                        ),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/svg/autumn.svg',
                            semanticsLabel: "Icon",
                            height: 24,
                          ),
                          title: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],
                            initialValue: '${plant.autumnCycle}',
                            decoration: InputDecoration(labelText: "Automne"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Donnez un cycle en automne à votre plante.";
                              }

                              return null;
                            },
                            onSaved: (value) => plant.setAutumnCycle(num.tryParse(value))
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}