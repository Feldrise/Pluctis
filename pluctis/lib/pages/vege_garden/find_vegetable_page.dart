import 'package:flutter/material.dart';
import 'package:pluctis/helpers/vege_info_helper.dart';
import 'package:pluctis/models/vegetable.dart';
import 'package:pluctis/models/vegetables_list.dart';
import 'package:pluctis/pages/vege_garden/vege_details_page.dart';
import 'package:pluctis/widgets/pluctis_card.dart';
import 'package:pluctis/widgets/pluctis_title.dart';
import 'package:provider/provider.dart';

class FindVegetablePage extends StatefulWidget {
  @override
  _FindVegetablePageState createState() => _FindVegetablePageState();
}

class _FindVegetablePageState extends State<FindVegetablePage> {
  Future<List<Vegetable>> _availableVegetables;

  final TextEditingController _controller = TextEditingController();
  String _filter;

  Future<List<Vegetable>> _fetchAvailableVegetables() async {
    final VegeInfoHelper helper = VegeInfoHelper.instance;

    return helper.availableVegetables();
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
    _availableVegetables ??= _fetchAvailableVegetables();

    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PluctisTitle(title: "Choisir une plante pour le potager"),
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
              future: _availableVegetables,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Vegetable> availableVegetables = snapshot.data as List<Vegetable>;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableVegetables.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: (_filter == null || _filter == "" ) || (availableVegetables[index].name.toLowerCase().contains(_filter.toLowerCase()) ),
                        child: GestureDetector(
                          onTap: () async {
                            final bool haveNewVegetable = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(
                                value: availableVegetables[index],
                                child: const VegeDetailsPage(isAddingVegetable: true,),
                              )),
                            );

                            if (haveNewVegetable != null && haveNewVegetable) {
                              final Vegetable newVegetable = availableVegetables[index]; 
                              
                              await Provider.of<VegetablesList>(context, listen: false).addVegetable(newVegetable);
                            }

                            Navigator.of(context).pop();
                          },
                          child: PluctisCard(
                            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                  child: Image(
                                    height: 96,
                                    image: AssetImage("assets/images/vegetables/${availableVegetables[index].slug}.png"), 
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(availableVegetables[index].name),
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