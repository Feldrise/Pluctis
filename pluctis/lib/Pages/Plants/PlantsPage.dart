import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Widgets/Plants/PlantGridItem.dart';
import 'package:provider/provider.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({Key key, @required this.onPush}) : super(key: key);

  final ValueChanged<String> onPush;

  PlantsPageState createState() => PlantsPageState();
}

class PlantsPageState extends State<PlantsPage> {

  // Get the number of columns to show depending on screen size
  int _numberOfColumns() {
    double width = MediaQuery.of(context).size.width;

    if (width > 1200) {
      return 6;
    }
    else if (width > 1000) {
      return 5;
    }
    else if (width > 800) {
      return 4;
    }
    else if (width > 600) {
      return 3;
    }

    return 2;
  }

  Future _tempAddPlants() async {
    PlantsInfoHelper plantsInfoHelper = PlantsInfoHelper.instance;

    Provider.of<PlantsList>(context, listen: false).addPlant(await plantsInfoHelper.plantFromInfo("aloe_vera"));
    Provider.of<PlantsList>(context, listen: false).addPlant(await plantsInfoHelper.plantFromInfo("aloe_vera"));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _tempAddPlants();
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
            padding: EdgeInsets.only(bottom: 72, left: 8, right: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Plantes", style: Theme.of(context).textTheme.title, textAlign: TextAlign.left,),
                Expanded(
                  child: GridView.builder(
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: _numberOfColumns(),
                      childAspectRatio: 2/3,
                    ),
                    itemCount: plants.allPlants.length,
                    itemBuilder: (context, index) {
                      var plant = plants.allPlants[index];
                      return ChangeNotifierProvider.value(
                        value: plant,
                        child: PlantGridItem(onPush: widget.onPush,),
                      );
                    },
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }
}