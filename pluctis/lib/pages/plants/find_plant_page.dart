import 'package:flutter/material.dart';
import 'package:pluctis/helpers/plants_info_helper.dart';
import 'package:pluctis/models/plant.dart';
import 'package:pluctis/models/plants_list.dart';
import 'package:pluctis/pages/plants/add_plant_page.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class FindPlantPage extends StatefulWidget {
  @override
  _FindPlantPageState createState() => _FindPlantPageState();
}

class _FindPlantPageState extends State<FindPlantPage> {
  Future<List<Plant>> _availablePlants;

  final TextEditingController _controller = TextEditingController();
  String _filter;

  Future<List<Plant>> _fetchAvailablePlants() async {
    final PlantsInfoHelper helper = PlantsInfoHelper.instance;

    return helper.availablePlants();
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
    _availablePlants ??= _fetchAvailablePlants();

    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PluctisTitle(title: "Choisir une plante"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Nom de la plante",
              ),
              controller: _controller,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _availablePlants,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Plant> availablePlants = snapshot.data as List<Plant>;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availablePlants.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: (_filter == null || _filter == "" ) || (availablePlants[index].name.toLowerCase().contains(_filter.toLowerCase()) ),
                        child: GestureDetector(
                          onTap: () async {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext  context) {
                                return AlertDialog(
                                  title: const Text("Date du dernier arrosage"),
                                  content: const Text("Veuillez indiquer la date du dernier arrosage"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Choisir", style: TextStyle(color: Theme.of(context).accentColor),),
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

                            final bool haveNewPlant = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                                value: availablePlants[index],
                                child: AddPlantPage(),
                              )),
                            );

                            if (haveNewPlant != null && haveNewPlant) {
                              final Plant newPlant = availablePlants[index]; 
                              newPlant.nextWatering = DateTime.now();
                              
                              await Provider.of<PlantsList>(context, listen: false).addPlant(newPlant);
                              await Provider.of<PlantsList>(context, listen: false).updatePlantWatering(picked, newPlant);
                            }

                            Navigator.of(context).pop();
                          },
                          child: PluctisCard(
                            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16), ),
                                  child: Image(
                                    height: 96,
                                    image: AssetImage("assets/images/plants/${availablePlants[index].slug}.png"), 
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(availablePlants[index].name),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                else if(snapshot.hasError) {
                  return Text("Nous n'avons pas pu récupérer de plante de notre base de données...\n${snapshot.error}");
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            )
          ),
        ],
      ),
    );
  }
}