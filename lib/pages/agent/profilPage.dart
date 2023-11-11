import 'package:flutter/material.dart';

class Agent {
  final String nom;
  final String prenom;
  final String adresse;
  final String telephone;

  Agent({
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
  });
}

class AgentProfilePage extends StatelessWidget {
  final Agent agent = Agent(
    nom: 'Doe',
    prenom: 'John',
    adresse: '123 rue Principale',
    telephone: '555-555-5555',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de l\'Agent'),
      ),
      body: Stack(
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
                SizedBox(height: 16),
                Text(
                  '${agent.nom} ${agent.prenom}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  agent.adresse,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  agent.telephone,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
