import 'package:flutter/material.dart';
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
    return Consumer<Plant>(
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
              tooltip: "Editer",
              child: Icon(Icons.check, color: Colors.white,),
              onPressed: () {
                print("Save plant pressed");
                _editIdentityFormKey.currentState.save();
                Navigator.of(context).pop(true);
              },
            ),
          ),
        );
      },
    );
  }
}