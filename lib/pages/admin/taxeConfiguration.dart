import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/activite_model.dart';
import '../../services/tax_management_service.dart';

class TaxConfigurationScreen extends StatefulWidget {
  @override
  State<TaxConfigurationScreen> createState() => _TaxConfigurationScreenState();
}

class _TaxConfigurationScreenState extends State<TaxConfigurationScreen> {
  PatenteManagement _patenteManagement = PatenteManagement();
  late Future<List<Activite>> _activitesFuture;
  List<Activite> _activites = [];

  @override
  void initState() {
    super.initState();
    _activitesFuture = getActivites();
  }

  Future<List<Activite>> getActivites() async {
    _activites = await _patenteManagement.getActivites();
    return _activites;
  }

  Future<void> _ajouterActivite(Activite activite) async {
    await _patenteManagement.ajouterActivite(activite,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
    _activitesFuture = getActivites();
    setState(() {});
  }

  Future<void> _deleteActivite(Activite activite) async {
    await _patenteManagement.supprimerActivite(activite,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

    _activitesFuture = getActivites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Activités Principales'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: TaxConfigurationForm(
              onAjouterActivite: _ajouterActivite,
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 3,
            child: TaxConfigurationList(
                activitesFuture: _activitesFuture,
                onDeleteActivite: _deleteActivite),
          ),
        ],
      ),
    );
  }
}

class TaxConfigurationForm extends StatefulWidget {
  final Function(Activite) onAjouterActivite;

  TaxConfigurationForm({required this.onAjouterActivite});

  @override
  _TaxConfigurationFormState createState() => _TaxConfigurationFormState();
}

class _TaxConfigurationFormState extends State<TaxConfigurationForm> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  int _droitFixeAnnuel = 0;
  String _description = '';

  // Fonction pour réinitialiser les champs du formulaire
  void resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _nom = '';
      _droitFixeAnnuel = 0;
      _description = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enregistrer une nouvelle activité principale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom de l\'activité'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le nom de l\'activité principale';
                }
                return null;
              },
              onSaved: (value) {
                _nom = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Droit Fixe Annuel'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le droit fixe annuel';
                }
                return null;
              },
              onSaved: (value) {
                _droitFixeAnnuel = int.parse(value!);
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir une description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final nouvelleActivite = Activite(
                    nom: _nom,
                    droitFixeAnnuel: _droitFixeAnnuel,
                    description: _description,
                  );
                  widget.onAjouterActivite(nouvelleActivite);

                  resetForm();
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class TaxConfigurationList extends StatefulWidget {
  final Future<List<Activite>> activitesFuture;
  final Function(Activite) onDeleteActivite;

  TaxConfigurationList({
    required this.activitesFuture,
    required this.onDeleteActivite,
  });

  @override
  _TaxConfigurationListState createState() => _TaxConfigurationListState();
}

class _TaxConfigurationListState extends State<TaxConfigurationList> {
  List<Activite> _filteredActivites = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.activitesFuture.then((activites) {
      setState(() {
        _filteredActivites = activites;
      });
    });

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _resetSearch();
      } else {
        _search(_searchController.text);
      }
    });
  }

  void _search(String query) {
    setState(() {
      _filteredActivites = _filteredActivites
          .where((activite) =>
              activite.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _resetSearch() {
    setState(() {
      _filteredActivites = _filteredActivites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liste des Activités Principales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _resetSearch();
                        });
                      },
                    )
                  : null,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredActivites.length,
              itemBuilder: (context, index) {
                final activite = _filteredActivites[index];
                return Card(
                  child: ListTile(
                    title: Text(activite.nom),
                    subtitle:
                        Text('Droit Fixe Annuel: ${activite.droitFixeAnnuel}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Ajoutez ici la logique de modification de l'activité
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text("Supprimer")),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content: SizedBox(
                                                          // width: 30,
                                                          height: 5,
                                                          child:
                                                              LinearProgressIndicator()));
                                                });
                                            widget.onDeleteActivite(activite);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Oui")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Non"))
                                    ],
                                  );
                                }).then((value) => null);
                            // Ajoutez ici la logique de suppression de l'activité
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
