import 'package:flutter/material.dart';
import 'package:pfe_block/model/agent_model.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';
import 'package:pfe_block/services/tax_management_service.dart';

class AgentProfilePage extends StatefulWidget {
  @override
  State<AgentProfilePage> createState() => _AgentProfilePageState();
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  PatenteManagement _patenteManagement = PatenteManagement();
  Future<Agent?> getAgent() async {
    Agent? agentSelected;

    List<Agent> agents = await _patenteManagement.getAgentAjouteEvents();
    String? addressAgent = await getUserEthAddress();
    for (Agent agent in agents) {
      if (agent.ethAddress.hexEip55 == addressAgent) {
        agentSelected = agent;
      }
    }
    return agentSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profil de l\'Agent'),
      ),
      body: FutureBuilder(
          future: getAgent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Agent agent = snapshot.data!;
              return Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Divider(),
                        Text(
                          '${agent.nom} ${agent.prenom}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          agent.adresse,
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          agent.telephone.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          }),
    );
  }
}
