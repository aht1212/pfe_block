
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques de Recouvrement',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StatisticCard(
                    icon: Icons.attach_money,
                    value: '1 234 567',
                    label: 'Montant Collecté',
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatisticCard(
                    icon: Icons.payment,
                    value: '890',
                    label: 'Taxes Payées',
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: StatisticCard(
                    icon: Icons.warning,
                    value: '456',
                    label: 'Taxes Impayées',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Activités Récents',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ActivityCard(
                    icon: Icons.attach_money,
                    title: 'Paiement Reçu',
                    subtitle: 'John Doe a payé 500€ pour sa taxe foncière.',
                    date: '09 Novembre 2023',
                  ),
                  SizedBox(height: 10),
                  ActivityCard(
                    icon: Icons.warning,
                    title: 'Avis d\'Échéance',
                    subtitle:
                        'L\'avis d\'échéance pour la taxe d\'habitation a été envoyé à tous les contribuables.',
                    date: '08 Novembre 2023',
                  ),
                  SizedBox(height: 10),
                  ActivityCard(
                    icon: Icons.attach_money,
                    title: 'Paiement Reçu',
                    subtitle: 'Jane Doe a payé 250€ pour sa taxe foncière.',
                    date: '07 Novembre 2023',
                  ),
                  SizedBox(height: 10),
                  ActivityCard(
                    icon: Icons.warning,
                    title: 'Avis d\'Échéance',
                    subtitle:
                        'L\'avis d\'échéance pour la taxe d\'habitation a été envoyé à tous les contribuables.',
                    date: '06 Novembre 2023',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatisticCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;

  ActivityCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 36),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text(date, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
