
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';
// import 'package:data_table_2/data_table_2.dart';

import '../../model/agent_model.dart';
import '../../signIn.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({Key? key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  PatenteManagement _patenteManagement = PatenteManagement();

  late Future<List<Agent>> _agentsFuture;
  late List<Agent> _agents;
  int _selectedRow = -1;
  Set<int> selectedRows = Set<int>();

  @override
  void initState() {
    super.initState();
    _agentsFuture = getAgents();
  }

  Future<List<Agent>> getAgents() async {
    _agents = await _patenteManagement.getAgentAjouteEvents();
    return _agents;
  }

  Future<void> _ajouterAgent(Agent agent) async {
    await _patenteManagement.ajouterAgent(agent,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

    // Mettez à jour la liste des agents après l'ajout
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    await usersRef
        .add({"email": agent.email, "adresseEth": agent.ethAddress.hexEip55});
    setState(() {
      _agentsFuture = getAgents();
    });
  }

  Future<void> _modifierAgent(Agent agent) async {
    await _patenteManagement.modifierAgent(agent,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

    // Mettez à jour la liste des agents après l'ajout
    setState(() {
      _agentsFuture = getAgents();
    });
  }

  Future<void> _deleteAgent(Agent agent) async {
    await _patenteManagement.supprimerAgent(agent.ethAddress,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));

// Ajouter un délai de 500 millisecondes avant de rafraîchir la liste des agents

    await Future.delayed(Duration(milliseconds: 500));

// Mettre à jour la liste des agents après la suppression
    _agentsFuture = getAgents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Section des agents
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Agents",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  FutureBuilder<List<Agent>>(
                    future: _agentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Erreur de chargement des agents.'));
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return Center(child: Text('Aucun agent enregistré.'));
                      } else {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: DataTable(
                              // dataRowColor: ,
                              dividerThickness: 1,
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              // minWidth: 600,
                              columns: [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Adresse Eth')),
                                DataColumn(label: Text('Nom')),
                                DataColumn(label: Text('Prénom')),
                                DataColumn(label: Text('Adresse')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Téléphone')),
                                DataColumn(label: Text("Actions"))
                              ],
                              rows: List<DataRow>.generate(
                                snapshot.data!.length,
                                (int index) {
                                  return DataRow(
                                    color: index == _selectedRow
                                        ? MaterialStatePropertyAll(
                                            Colors.blueGrey.withOpacity(0.8))
                                        : index % 2 == 0
                                            ? MaterialStatePropertyAll(Colors
                                                .blueGrey
                                                .withOpacity(0.3))
                                            : null,
                                    selected: index == _selectedRow,
                                    onSelectChanged: (selected) {
                                      setState(() {
                                        _selectedRow = selected! ? index : -1;
                                      });
                                      // return true;
                                    },
                                    cells: [
                                      DataCell(Text(
                                          snapshot.data![index].id.toString())),
                                      DataCell(Text(snapshot
                                          .data![index].ethAddress
                                          .toString())),
                                      DataCell(Text(snapshot.data![index].nom)),
                                      DataCell(
                                          Text(snapshot.data![index].prenom)),
                                      DataCell(
                                          Text(snapshot.data![index].adresse)),
                                      DataCell(
                                          Text(snapshot.data![index].email)),
                                      DataCell(Text(snapshot
                                          .data![index].telephone
                                          .toString())),
                                      DataCell(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                            child: Text(
                                                                "*********** Modifier Agent ***********")),
                                                        content: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.8,
                                                          child: Card(
                                                            child: AgentForm(
                                                              ajouterAgent:
                                                                  _modifierAgent,
                                                              agentToModify:
                                                                  snapshot.data![
                                                                      index],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).then((value) {
                                                  return value;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                            child: Text(
                                                                "Supprimer")),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          content: SizedBox(
                                                                              // width: 30,
                                                                              height: 5,
                                                                              child: LinearProgressIndicator()));
                                                                    });
                                                                await _deleteAgent(
                                                                        snapshot.data![
                                                                            index])
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    _agentsFuture =
                                                                        getAgents();
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  return null;
                                                                });
                                                                Future<List<Agent>>
                                                                    updateAgents() async {
                                                                  _agents =
                                                                      await _patenteManagement
                                                                          .getAgentAjouteEvents();
                                                                  return _agents;
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {
                                                                  _agentsFuture =
                                                                      updateAgents();
                                                                });
                                                              },
                                                              child:
                                                                  Text("Oui")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("Non"))
                                                        ],
                                                      );
                                                    }).then((value) => null);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            )
                                          ]))
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child: Text("*********** Ajouter Agent ***********")),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Card(
                      child: AgentForm(
                        ajouterAgent: _ajouterAgent,
                      ),
                    ),
                  ),
                );
              }).then((value) {
            return value;
          });
        },
        child: Icon(Icons.person_add_alt),
      ),
    );
  }
}

class AgentForm extends StatefulWidget {
  final Function(Agent) ajouterAgent;
  final Agent? agentToModify;
  const AgentForm(
      {super.key,
      required this.ajouterAgent,
      this.agentToModify}); // Ajouter cette propriété
  @override
  _AgentFormState createState() => _AgentFormState();
}

class _AgentFormState extends State<AgentForm> {
  // Créez des contrôleurs pour les champs du formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _adresseEthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  PatenteManagement _patenteManagement = PatenteManagement();

  @override
  void initState() {
    super.initState();
    // Initialisez les champs du formulaire avec les valeurs de l'agent à modifier
    if (widget.agentToModify != null) {
      _adresseEthController.text = widget.agentToModify!.ethAddress.hex;
      _nomController.text = widget.agentToModify!.nom;
      _prenomController.text = widget.agentToModify!.prenom;
      _adresseController.text = widget.agentToModify!.adresse;
      _emailController.text = widget.agentToModify!.email;
      _telephoneController.text = widget.agentToModify!.telephone.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            gap(),

            TextFormField(
              enabled: widget.agentToModify == null,
              controller: _adresseEthController,
              decoration: InputDecoration(labelText: 'Adresse Ethereum'),
            ),
            gap(),
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            gap(),
            TextFormField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            gap(),
            TextFormField(
              controller: _adresseController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            gap(),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            gap(),
            TextFormField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: 'Téléphone'),
            ),
            // Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Ajoutez le code pour enregistrer l'agent ici
                // Vous pouvez  utiliser les valeurs des contrôleurs
                if (_formKey.currentState!.validate()) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                            width: 30,
                            height: 30,
                            child: LinearProgressIndicator());
                      });

                  await widget.ajouterAgent(
                    Agent(
                        ethAddress:
                            EthereumAddress.fromHex(_adresseEthController.text),
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        adresse: _adresseController.text,
                        email: _emailController.text,
                        telephone: int.parse(_telephoneController.text)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Ajouter avec succès')));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Champs invalides')));
                }
                Navigator.of(context).pop();
                // Fermer la boîte de dialogue après l'ajout
              },
              child: Text(widget.agentToModify != null
                  ? 'Modifier Agent'
                  : 'Ajouter Agent'),
            ),
          ],
        ),
      ),
    );
  }
}
