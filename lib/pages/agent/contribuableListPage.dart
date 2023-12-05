import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/model/agent_model.dart';
import 'package:pfe_block/model/patente_model.dart';
import 'package:pfe_block/pages/agent/contribuable_selected_page.dart';
import 'package:pfe_block/services/tax_management_service.dart';

import '../../model/contribuable_model.dart';

enum TypeContribuable {
  particulier,
  entreprise,
}

Future<String?> getUserEthAddress() async {
  String? address;
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await usersRef.where("email", isEqualTo: currentUser.email).get();
    if (querySnapshot.docs.isNotEmpty) {
      address = querySnapshot.docs.first['adresseEth'];
      return querySnapshot.docs.first['adresseEth'];
    }
  }
  return address;
}

class ContribuablesListPage extends StatefulWidget {
  @override
  State<ContribuablesListPage> createState() => _ContribuablesListPageState();
}

class _ContribuablesListPageState extends State<ContribuablesListPage> {
  List<Contribuable> _contribuables = [];

  PatenteManagement _patenteManagement = PatenteManagement();

  late Future<List<Contribuable>> _contribuablesFuture;

  @override
  void initState() {
    super.initState();
    _contribuablesFuture = getContribuables();
  }

  List<Patente> _patentesPayer = [];
  Future<List<Contribuable>> getContribuables() async {
    List<Contribuable> contrib =
        await _patenteManagement.getContribuableAjouteEvents();
    List<Agent> agents = await _patenteManagement.getAgentAjouteEvents();
    String? addressAgent = await getUserEthAddress();
    Agent? agentSelected;
    for (Agent agent in agents) {
      if (agent.ethAddress.hexEip55 == addressAgent) {
        agentSelected = agent;
      }
    }

    for (var element in contrib) {
      if (element.agentId == agentSelected!.id!) {
        _contribuables.add(element);
      }
    }
    _patentesPayer = await _patenteManagement.getPatentesPayer();

    return _contribuables;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Contribuables'),
      ),
      body: FutureBuilder(
          future: _contribuablesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement des agents.'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun agent enregistré.'));
            } else {
              return ListView.separated(
                itemCount: _contribuables.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  Contribuable contribuable = _contribuables[index];
                  var patenteAPayer = _patentesPayer.any((element) =>
                      element.contribuableId == contribuable.id &&
                      element.anneePaiement == DateTime.now().year);
                  return ListTile(
                    leading: _buildAvatar(contribuable, patenteAPayer, context),
                    title: Text('${contribuable.denomination}'),
                    subtitle: Text(contribuable.adresse),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  ContribuableSelectedPage(
                                      contribuableId: contribuable.id!)));

                      // TODO: Ajouter la logique pour afficher les détails du contribuable sélectionné.
                    },
                  );
                },
              );
            }
          }),
    );
  }

  Widget _buildAvatar(
      Contribuable type, bool patentAPayer, BuildContext context) {
    if (type.typeContribuable.toLowerCase() == "particulier") {
      return Badge(
        backgroundColor: !patentAPayer ? Colors.red : Colors.transparent,
        child: CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return Badge(
        backgroundColor: !patentAPayer ? Colors.red : Colors.transparent,
        child: CircleAvatar(
          child: Icon(
            Icons.business,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
