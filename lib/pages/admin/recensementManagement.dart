import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/contribuable_model.dart';
import '../../services/tax_management_service.dart';

class RecensementManagementScreen extends StatefulWidget {
  const RecensementManagementScreen({super.key});

  @override
  State<RecensementManagementScreen> createState() =>
      _RecensementManagementScreenState();
}

class _RecensementManagementScreenState
    extends State<RecensementManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: RegisterContribuableForm()),
        Expanded(flex: 5, child: ContribuableList())
      ],
    );
  }
}

class RegisterContribuableForm extends StatefulWidget {
  @override
  _RegisterContribuableFormState createState() =>
      _RegisterContribuableFormState();
}

class _RegisterContribuableFormState extends State<RegisterContribuableForm> {
  final _formKey = GlobalKey<FormState>();
  String _ethAdress = "";
  String _name = '';
  String _nif = '';
  String _denomination = '';
  int _activitePrincipaleId = 0;
  String _prenom = '';
  String _adresse = '';
  String _email = '';
  int _contact = 0;
  String _typeContribuable = '';
  int _valeurLocative = 0;
  PatenteManagement _patenteManagement = PatenteManagement();
  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text("Chargement en cours..."),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Ajouter un contribuable"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Adresse Compte'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir l adresse du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _ethAdress = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Nom du contribuable'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir le nom du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Prénom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir le prénom du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _prenom = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'NIF'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir le NIF';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nif = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Dénomination'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir la dénomination du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _denomination = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "ID de l'activité principal"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir l'ID de l'activité principale";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _activitePrincipaleId = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Adresse'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir l'adresse du contribuable";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _adresse = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez saisir l'email du contribuable";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Contact'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir le contact du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _contact = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Type de contribuable'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir le type de contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _typeContribuable = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Valeur locative'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir la valeur locative du contribuable';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _valeurLocative = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // await patenteManagement.getAllContribuables();
                  // await patenteManagement.getContribuableAjouteEvents();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Appel de la fonction pour enregistrer le contribuable en utilisant Web3dart

                    await _patenteManagement.ajouterContribuable(
                        Contribuable(
                            ethAddress: EthereumAddress.fromHex(_ethAdress),
                            nif: _nif,
                            denomination: _denomination,
                            activitePrincipaleId: _activitePrincipaleId,
                            nom: _name,
                            prenom: _prenom,
                            adresse: _adresse,
                            email: _email,
                            contact: _contact,
                            valeurLocative: _valeurLocative,
                            typeContribuable: _typeContribuable,
                            dateCreation: DateTime.now().toLocal().toString()),
                        EthereumAddress.fromHex(
                            "0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> enregistrerContribuable(
    EthereumAddress ethAddress,
    String name,
    String nif,
    String denomination,
    int activitePrincipaleId,
    String prenom,
    String adresse,
    String email,
    int contact,
    String typeContribuable,
    int valeurLocative,
  ) async {
    // Connexion au nœud Ethereum en utilisant Web3dart

    // Appel de la fonction pour enregistrer le contribuable
    await _patenteManagement.ajouterContribuable(
        Contribuable(
          ethAddress: ethAddress,
          nom: name,
          nif: nif,
          denomination: denomination,
          activitePrincipaleId: activitePrincipaleId,
          prenom: prenom,
          adresse: adresse,
          email: email,
          contact: contact,
          typeContribuable: typeContribuable,
          valeurLocative: valeurLocative,
          dateCreation: DateTime.now().toString(),
        ),
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
  }
}

class ContribuableList extends StatefulWidget {
  const ContribuableList({super.key});

  @override
  State<ContribuableList> createState() => _ContribuableListState();
}

class _ContribuableListState extends State<ContribuableList> {
  List<Contribuable> _contribuables = [];
  PatenteManagement _patenteManagement = PatenteManagement();
  Future<List<Contribuable>> getContribuables() async {
    _contribuables = await _patenteManagement.getContribuableAjouteEvents();
    return _contribuables;
  }

  late Future<List<Contribuable>> _contribuablesFuture;

  @override
  void initState() {
    super.initState();
    _contribuablesFuture = getContribuables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Liste de contribuables "),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: _contribuablesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur de chargement des agents.'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun agent enregistré.'));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              const DataColumn(label: Text('Nom')),
                              const DataColumn(label: Text('Prénom')),
                              const DataColumn(label: Text('Dénomination')),

                              // const DataColumn(label: Text('NIF')),
                              const DataColumn(label: Text('Adresse')),
                              const DataColumn(label: Text('Type')),
                              const DataColumn(label: Text('Actions')),
                            ],
                            rows: _contribuables.map((contribuable) {
                              return DataRow(cells: [
                                DataCell(Text(contribuable.nom)),
                                DataCell(Text(contribuable.prenom)),
                                DataCell(Text(contribuable.denomination)),
                                DataCell(Text(contribuable.adresse)),
                                DataCell(Text(contribuable.typeContribuable)),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // Ouvrir l'écran de modification du Contribuable
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => EditContribuableScreen(
                                        //       contribuable: contribuable,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        // Supprimer le Contribuable

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title:
                                                      new Text("Confirmation"),
                                                  content: new Text(
                                                      "Voulez-vous supprimer ce contribuable?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: new Text("Annuler",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent)),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text(
                                                        "Oui",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                      onPressed: () async {
                                                        showLoadingDialog();
                                                        await _patenteManagement
                                                            .supprimerContribuable(
                                                                contribuable
                                                                    .ethAddress,
                                                                EthereumAddress
                                                                    .fromHex(
                                                                        "0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ]);
                                            }).then((value) {
                                          Future<List<Contribuable>>
                                              refreshContribuables() async {
                                            _contribuables =
                                                await _patenteManagement
                                                    .getContribuableAjouteEvents();

                                            Navigator.pop(context);

                                            return _contribuables;
                                          }

                                          setState(() {
                                            _contribuablesFuture =
                                                refreshContribuables();
                                          });
                                          return null;
                                        });
                                      },
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text("Chargement en cours..."),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
