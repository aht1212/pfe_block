import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/model/activite_model.dart';
import 'package:pfe_block/model/agent_model.dart';
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
  final PatenteManagement _patenteManagement = PatenteManagement();

  List<Contribuable> _contribuables = [];

  Future<List<Contribuable>> getContribuables() async {
    _contribuables = await _patenteManagement.getContribuableAjouteEvents();
    return _contribuables;
  }

  late Future<List<Contribuable>> _contribuableFuture;

  @override
  void initState() {
    super.initState();
    _contribuableFuture = getContribuables();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: ContribuableList(
              contribuableListFuture: _contribuableFuture,
            ))
      ],
    );
  }
}

class RegisterContribuableForm extends StatefulWidget {
  const RegisterContribuableForm({
    super.key,
  });

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
  int _nbreEmployes = 0;
  int _agentId = 0;

  String _typeContribuable = '';
  int _valeurLocative = 0;
  PatenteManagement _patenteManagement = PatenteManagement();

  TextEditingController _activitePrincipaleController = TextEditingController();
  TextEditingController _agentFormController = TextEditingController();
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

  List<Activite> activites = [];
  List<Agent> agents = [];
  Activite? selectedMenu;
  Agent? selectedMenuAgent;
  Future<List<Activite>> getActivites() async {
    activites = await _patenteManagement.getActivites();
    return activites;
  }

  Future<List<Agent>> getAgents() async {
    agents = await _patenteManagement.getAgentAjouteEvents();
    return agents;
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
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 6.0,
                  shrinkWrap: true,
                  childAspectRatio: 3,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextFormField(
                      labelText: 'Adresse Compte',
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
                    buildTextFormField(
                      labelText: 'Nom du contribuable',
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
                    buildTextFormField(
                      labelText: 'Prénom',
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
                    buildTextFormField(
                      labelText: 'NIF',
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
                    buildTextFormField(
                      labelText: 'Dénomination',
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
                    FutureBuilder(
                        future: getActivites(),
                        builder: (context, snapshot) {
                          return MenuAnchor(
                            builder: (BuildContext context,
                                MenuController controller, Widget? child) {
                              return buildTextFormField(
                                onTap: () {
                                  if (controller.isOpen) {
                                    controller.close();
                                  } else {
                                    controller.open();
                                  }
                                },
                                readOnly: true,
                                controller: _activitePrincipaleController,
                                labelText: "activité principal",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez Selectionner une activité principale";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _activitePrincipaleId = selectedMenu!.id!;
                                },
                              );
                            },
                            menuChildren: List.generate(
                              activites.length,
                              (int index) => SizedBox(
                                width: 200,
                                child: Center(
                                  child: MenuItemButton(
                                    onPressed: () => setState(() {
                                      selectedMenu = activites[index];
                                      _activitePrincipaleController.text =
                                          selectedMenu?.nom ?? '';
                                    }),
                                    child: Text(activites[index].nom),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       labelText: "ID de l'activité principal"),
                    //   keyboardType: TextInputType.number,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Veuillez saisir l'ID de l'activité principale";
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _activitePrincipaleId = int.parse(value!);
                    //   },
                    // ),
                    buildTextFormField(
                      labelText: 'Adresse',
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
                    buildTextFormField(
                      labelText: 'Email',
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
                    buildTextFormField(
                      labelText: 'Contact',
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
                    buildTextFormField(
                      labelText: 'Type de contribuable',
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
                    buildTextFormField(
                      labelText: 'Valeur locative',
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
                    buildTextFormField(
                      labelText: 'Nombre d\'employés',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir la Nombre d\'employé ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nbreEmployes = int.parse(value!);
                      },
                    ),
                    FutureBuilder(
                        future: getAgents(),
                        builder: (context, snapshot) {
                          return MenuAnchor(
                            builder: (BuildContext context,
                                MenuController controller, Widget? child) {
                              return buildTextFormField(
                                onTap: () {
                                  if (controller.isOpen) {
                                    controller.close();
                                  } else {
                                    controller.open();
                                  }
                                },
                                readOnly: true,
                                controller: _agentFormController,
                                labelText: "Agent chargé du suivi",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez Selectionner un agent";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _agentId = selectedMenuAgent!.id!;
                                },
                              );
                            },
                            menuChildren: List.generate(
                              agents.length,
                              (int index) => SizedBox(
                                width: 200,
                                child: Center(
                                  child: MenuItemButton(
                                    onPressed: () => setState(() {
                                      selectedMenuAgent = agents[index];
                                      _agentFormController.text =
                                          selectedMenuAgent?.nom ?? '';
                                    }),
                                    child: Text(agents[index].nom),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  showLoadingDialog();

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
                          typeContribuable: _typeContribuable,
                          dateCreation: DateTime.now().toLocal().toString(),
                          valeurLocative: _valeurLocative,
                          nombreEmployes: _nbreEmployes,
                          anneeModification:
                              DateTime.now().toLocal().toString(),
                          agentId: _agentId,
                        ),
                        EthereumAddress.fromHex(
                            "0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

                    CollectionReference usersRef =
                        FirebaseFirestore.instance.collection('users');

                    await usersRef
                        .add({"email": _email, "adresseEth": _ethAdress});
                  }

                  Navigator.of(context).pop();
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      {required String labelText,
      required Function(String?) onSaved,
      required String? Function(String?)? validator,
      bool readOnly = false,
      TextEditingController? controller,
      Function()? onTap,
      TextInputType? keyboardType}) {
    return TextFormField(
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      onSaved: onSaved,
      readOnly: readOnly,
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
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
    int agentId,
    int nbreEmployee,
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
          nombreEmployes: nbreEmployee,
          anneeModification: DateTime.now().toString(),
          agentId: agentId,
        ),
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
  }
}

class ContribuableList extends StatefulWidget {
  final Future<List<Contribuable>> contribuableListFuture;
  const ContribuableList({super.key, required this.contribuableListFuture});

  @override
  State<ContribuableList> createState() => _ContribuableListState();
}

class _ContribuableListState extends State<ContribuableList> {
  List<Contribuable> _contribuables = [];
  PatenteManagement _patenteManagement = PatenteManagement();

  late Future<List<Contribuable>> _contribuablesFuture;

  @override
  void initState() {
    super.initState();
    _contribuablesFuture = widget.contribuableListFuture;
  }

  Future<void> _ajouterContribuable(Contribuable contribuable) async {
    await _patenteManagement.ajouterContribuable(contribuable,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

    setState(() {
      _contribuablesFuture = widget.contribuableListFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_business_sharp),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Ajouter un nouveau contributable'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: RegisterContribuableForm(),
                      ));
                }).then((value) {
              Future<List<Contribuable>> updateContribuables() async {
                _contribuables =
                    await _patenteManagement.getContribuableAjouteEvents();
                return _contribuables;
              }

              setState(() {
                _contribuablesFuture = updateContribuables();
              });
              return null;
            });
          }),
      appBar: AppBar(
        title: Center(
          child: Text("Liste de contribuables "),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
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
                    _contribuables = snapshot.data!;
                    return Card(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: [
                            const DataColumn(label: Text('Nom')),
                            const DataColumn(label: Text('Prénom')),
                            const DataColumn(label: Text('Dénomination')),
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
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      // Supprimer le Contribuable

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: new Text("Confirmation"),
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
                                                          color:
                                                              Colors.redAccent),
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
                    );
                  }
                }),
          ),
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
