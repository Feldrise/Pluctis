import 'package:flutter/material.dart';
import 'package:pluctis/Helpers/VegeInfoHelper.dart';
import 'package:pluctis/Models/Vegetable.dart';
import 'package:pluctis/Models/VegetablesList.dart';
import 'package:pluctis/Pages/VegeGarden/VegeDetailsPage.dart';
import 'package:provider/provider.dart';

class FindVegetablePage extends StatefulWidget {
  FindVegetablePageState createState() => FindVegetablePageState();
}

class FindVegetablePageState extends State<FindVegetablePage> {
  Future<List<Vegetable>> _availableVegetables;

  TextEditingController _controller = new TextEditingController();
  String _filter;

  Future<List<Vegetable>> _fetchAvailableVegetables() async {
    VegeInfoHelper helper = VegeInfoHelper.instance;

    return await helper.availableVegetables();
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
    if (_availableVegetables == null) {
      _availableVegetables = _fetchAvailableVegetables();
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(),
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
            Text("Choisir une plante pour le potager", style: Theme.of(context).textTheme.title,),
            TextField(
              decoration: InputDecoration(
                labelText: "Nom de la plante",
              ),
              controller: _controller,
            ),
            Expanded(
              child: FutureBuilder(
                future: _availableVegetables,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Vegetable> availableVegetables = snapshot.data;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableVegetables.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: (_filter == null || _filter == "" ) || (availableVegetables[index].name.toLowerCase().contains(_filter.toLowerCase()) ),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(0)),
                                    child: Image(
                                      height: 96,
                                      image: AssetImage("assets/images/vegetables/${availableVegetables[index].slug}.png"), 
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(availableVegetables[index].name),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              print("Plant selected");

                              bool haveNewVegetable = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                                  value: availableVegetables[index],
                                  child: VegeDetailsPage(isAddingVegetable: true,),
                                )),
                              );

                              if (haveNewVegetable != null && haveNewVegetable) {
                                Vegetable newVegetable = availableVegetables[index]; 
                                
                                await Provider.of<VegetablesList>(context, listen: false).addVegetable(newVegetable);
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