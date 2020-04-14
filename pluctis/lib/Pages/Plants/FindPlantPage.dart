import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/PlantsInfoHelper.dart';
import 'package:pluctis/Models/Plant.dart';

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
        padding: EdgeInsets.only(bottom: 96, top: 8, left: 8, right: 8),
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
            FutureBuilder(
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
                          onTap: () {
                            print("Plant selected");
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
          ],
        ),
      ),
    );
  }
}