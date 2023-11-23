import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';

class MarchesScreen extends StatefulWidget {
  @override
  _MarchesScreenState createState() => _MarchesScreenState();
}

class _MarchesScreenState extends State<MarchesScreen> {
  List<Marche> _marches = [];

  List<Marche> filteredMarches = [];
  late Future<List<Marche>> _futureMarche;
  PatenteManagement _patenteManagement = PatenteManagement();
  String searchQuery = '';
  bool showOnlyOccupiedMarches = false;
  Future<List<Marche>> getMarches() async {
    _marches = await _patenteManagement.getMarcheAjouteEvents();
    return _marches;
  }

  @override
  void initState() {
    super.initState();
    _futureMarche = getMarches();
    filteredMarches = _marches;
  }

  void filterMarches() {
    setState(() {
      filteredMarches = _marches.where((market) {
        final lowerCaseQuery = searchQuery.toLowerCase();
        final lowerCaseNom = market.nom.toLowerCase();
        return lowerCaseNom.contains(lowerCaseQuery) &&
            (!showOnlyOccupiedMarches || market.placesOccupees > 0);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Marchés'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher un marché',
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filterMarches();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Afficher uniquement les marchés occupés'),
            trailing: Switch(
              value: showOnlyOccupiedMarches,
              onChanged: (value) {
                setState(() {
                  showOnlyOccupiedMarches = value;
                  filterMarches();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _futureMarche,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: _marches.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text(_marches[index].nom),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Nombre de places: ${_marches[index].nombrePlaces}'),
                              Text(
                                  'Prix par place: ${_marches[index].prixPlace}'),
                              Text(
                                  'Places occupées: ${_marches[index].placesOccupees}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Action when edit button is pressed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Modifier le marché'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Nom du marché',
                                          ),
                                          onChanged: (value) {
                                            // Update market name
                                            setState(() {
                                              filteredMarches[index].nom =
                                                  value;
                                            });
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Nombre de places',
                                          ),
                                          onChanged: (value) {
                                            // Update number of places
                                            setState(() {
                                              filteredMarches[index]
                                                      .nombrePlaces =
                                                  int.parse(value);
                                            });
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Prix par place',
                                          ),
                                          onChanged: (value) {
                                            // Update price per place
                                            setState(() {
                                              filteredMarches[index].prixPlace =
                                                  int.parse(value);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Annuler'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Enregistrer'),
                                        onPressed: () {
                                          // Save market changes
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          onLongPress: () {
                            // Action when market is long pressed (e.g. delete)
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Supprimer le marché'),
                                  content: Text(
                                      'Êtes-vous sûr de vouloir supprimer ce marché ?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Annuler'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Supprimer'),
                                      onPressed: () {
                                        setState(() {
                                          filteredMarches.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator.adaptive();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Action when add button is pressed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newMarketName = '';
              int newMarketNombrePlaces = 0;
              int newMarketPrixPlace = 0;

              return AlertDialog(
                title: Text('Ajouter un marché'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom du marché',
                      ),
                      onChanged: (value) {
                        newMarketName = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre de places',
                      ),
                      onChanged: (value) {
                        newMarketNombrePlaces = int.parse(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Prix par place',
                      ),
                      onChanged: (value) {
                        newMarketPrixPlace = int.parse(value);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Ajouter'),
                    onPressed: () {
                      setState(() {
                        _marches.add(Marche(
                          id: _marches.length + 1,
                          nom: newMarketName,
                          nombrePlaces: newMarketNombrePlaces,
                          prixPlace: newMarketPrixPlace,
                          placesOccupees: 0,
                        ));
                        filterMarches();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class Marche {
  final int id;
  String nom;
  int nombrePlaces;
  int prixPlace;
  int placesOccupees;

  Marche({
    required this.id,
    required this.nom,
    required this.nombrePlaces,
    required this.prixPlace,
    required this.placesOccupees,
  });

  factory Marche.fromEvent(List<dynamic> json) {
    return Marche(
        id: json[0].toInt(),
        nom: json[1],
        nombrePlaces: json[2].toInt(),
        prixPlace: json[3].toInt(),
        placesOccupees: json[4].toInt());
  }
  // Marche.toJson()
}
