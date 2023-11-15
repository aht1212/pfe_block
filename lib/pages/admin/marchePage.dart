import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class MarchesScreen extends StatefulWidget {
  @override
  _MarchesScreenState createState() => _MarchesScreenState();
}

class _MarchesScreenState extends State<MarchesScreen> {
  List<Marche> markets = [
    Marche(
      id: 1,
      nom: 'Market 1',
      nombrePlaces: 50,
      prixPlace: 10,
      placesOccupees: 20,
    ),
    Marche(
      id: 2,
      nom: 'Market 2',
      nombrePlaces: 30,
      prixPlace: 15,
      placesOccupees: 10,
    ),
    Marche(
      id: 3,
      nom: 'Market 3',
      nombrePlaces: 40,
      prixPlace: 12,
      placesOccupees: 30,
    ),
  ];

  List<Marche> filteredMarkets = [];

  String searchQuery = '';
  bool showOnlyOccupiedMarkets = false;

  @override
  void initState() {
    super.initState();
    filteredMarkets = markets;
  }

  void filterMarkets() {
    setState(() {
      filteredMarkets = markets.where((market) {
        final lowerCaseQuery = searchQuery.toLowerCase();
        final lowerCaseNom = market.nom.toLowerCase();
        return lowerCaseNom.contains(lowerCaseQuery) &&
            (!showOnlyOccupiedMarkets || market.placesOccupees > 0);
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
                  filterMarkets();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Afficher uniquement les marchés occupés'),
            trailing: Switch(
              value: showOnlyOccupiedMarkets,
              onChanged: (value) {
                setState(() {
                  showOnlyOccupiedMarkets = value;
                  filterMarkets();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredMarkets.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(filteredMarkets[index].nom),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Nombre de places: ${filteredMarkets[index].nombrePlaces}'),
                      Text(
                          'Prix par place: ${filteredMarkets[index].prixPlace}'),
                      Text(
                          'Places occupées: ${filteredMarkets[index].placesOccupees}'),
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
                                      filteredMarkets[index].nom = value;
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
                                      filteredMarkets[index].nombrePlaces =
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
                                      filteredMarkets[index].prixPlace =
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
                                  filteredMarkets.removeAt(index);
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
            ),
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
                        markets.add(Marche(
                          id: markets.length + 1,
                          nom: newMarketName,
                          nombrePlaces: newMarketNombrePlaces,
                          prixPlace: newMarketPrixPlace,
                          placesOccupees: 0,
                        ));
                        filterMarkets();
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
