import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';
import 'package:pluctis/Models/Plant.dart';
import 'package:pluctis/Models/PlantsList.dart';
import 'package:pluctis/Pages/Plants/AddPlantPage.dart';
import 'package:provider/provider.dart';

class FindPlantPage extends StatefulWidget {
  FindPlantPageState createState() => FindPlantPageState();
}

class FindPlantPageState extends State<FindPlantPage> {
  Future<List<Plant>> _availablePlants;

  TextEditingController _controller = new TextEditingController();
  String _filter;

  Future<List<Plant>> _fetchAvailablePlants() async {
    PlantsInfoHelper helper = PlantsInfoHelper.instance;

    return await helper.availablePlants();
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _filter = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_availablePlants == null) {
      _availablePlants = _fetchAvailablePlants();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 72, top: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Choisir une plante", style: Theme.of(context).textTheme.title,),
            TextField(
              decoration: InputDecoration(
                labelText: "Nom de la plante",
              ),
              controller: _controller,
            ),
            Expanded(
              child: FutureBuilder(
                future: _availablePlants,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Plant> availablePlants = snapshot.data;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: availablePlants.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: (_filter == null || _filter == "" ) || (availablePlants[index].name.toLowerCase().contains(_filter.toLowerCase()) ),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(0)),
                                    child: Image(
                                      height: 96,
                                      image: AssetImage("assets/images/plants/${availablePlants[index].slug}.png"), 
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(availablePlants[index].name),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              print("Plant selected");
                              await showDialog(
                                context: context,
                                builder: (BuildContext  context) {
                                  return AlertDialog(
                                    title: Text("Date du dernier arrosage"),
                                    content: Text("Veuillez indiquer la date du dernier arrosage"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Choisir", style: TextStyle(color: Theme.of(context).accentColor),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                }
                              );

                              final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101)
                              );

                              if (picked == null) {
                                Navigator.of(context).pop();
                                return;
                              }

                              bool haveNewPlant = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                                  value: availablePlants[index],
                                  child: AddPlantPage(),
                                )),
                              );

                              if (haveNewPlant != null && haveNewPlant) {
                                Plant newPlant = availablePlants[index]; 
                                newPlant.nextWatering = DateTime.now();
                                
                                await Provider.of<PlantsList>(context, listen: false).addPlant(newPlant);
                                await Provider.of<PlantsList>(context, listen: false).updatePlantWatering(picked, newPlant);
                              }

                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    );
                  }
                  else if(snapshot.hasError) {
                    return Text("Nous n'avons pas pu récupérer de plante de notre base de données...\n${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}