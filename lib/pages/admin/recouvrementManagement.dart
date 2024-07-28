import 'package:flutter/material.dart';
import 'package:pfe_block/model/demandeOccupation_model.dart';

class RecouvrementManagementScreen extends StatelessWidget {
  final List<DemandeOccupation> demandeOccupations = [
    DemandeOccupation(
        idoccupation: 1,
        idMarche: 123,
        dateDebut: "2023-01-01",
        dateFin: "2023-01-31",
        idContribuable: 456,
        estValidee: false),
    // Ajoutez d'autres événements de type DemandeOccupation si nécessaire
  ];

  final List<DemandeOccupationValidee> demandeOccupationsValidees = [
    DemandeOccupationValidee(
      idoccupation: 2,
      idMarche: 789,
      place: 42,
      dateDebut: "2023-02-01",
      dateFin: "2023-02-28",
      idContribuable: 789,
      // addressAgent: "0x123abc...",
    ),
    // Ajoutez d'autres événements de type DemandeOccupationValidee si nécessaire
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion du Recouvrement'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Demandes d\'Occupation'),
              Tab(text: 'Demandes Validées'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventList(demandeOccupations),
            _buildEventList(demandeOccupationsValidees),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<dynamic> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildEventCard(context, events[index]),
    );
  }

  Widget _buildEventCard(BuildContext context, dynamic event) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Occupation: ${event.idoccupation}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'ID Marché: ${event.idMarche}\nDate Début: ${event.dateDebut}\nDate Fin: ${event.dateFin}\nID Contribuable: ${event.idContribuable}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
