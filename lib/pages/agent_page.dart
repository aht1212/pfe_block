import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)),
        ),
        body: AgentRecouvrementHomePage());
  }
}

class AgentRecouvrementHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            'Bienvenue, Agent de Recouvrement !',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        // Naviguer vers le tableau de bord
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()),
                        );
                      },
                      icon: Icon(Icons.dashboard),
                      label: Text('Tableau de bord'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        // Naviguer vers la liste des contribuables
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContribuablesListPage()),
                        );
                      },
                      icon: Icon(Icons.list),
                      label: Text('Liste des Contribuables'),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Theme.of(context).primaryColor,
                        // textStyle: TextStyle(
                        //   color: Colors.white,
                        // ),
                        fixedSize: Size(100, 100),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        // Naviguer vers le profil de l'agent
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgentProfilePage()),
                        );
                      },
                      icon: Icon(Icons.person),
                      label: Text('Profil de l\'Agent'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        // Naviguer vers les paramètres
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                      },
                      icon: Icon(Icons.settings),
                      label: Text('Paramètres'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

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

  StatisticCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 36, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(label, style: TextStyle(color: Colors.grey)),
              ],
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

class ContribuablesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Contribuables'),
      ),
      body: Center(
        child: Text('Liste des contribuables et informations'),
      ),
    );
  }
}

class AgentProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de l\'Agent'),
      ),
      body: Center(
        child: Text('Informations du profil de l\'agent'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Center(
        child: Text('Paramètres de l\'application'),
      ),
    );
  }
}

// class CardListView extends StatelessWidget {
//   const CardListView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 25.0, right: 25.0, bottom: 15.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: 175,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: [
//             Card(
//                 "Vegan",
// Icons.dashboard,                 "8 min away"),
//             Card(
//                 "Italian ",Icons.person
//                 "12 min away"),
//             Card(
//                 "Vegan",
//                 "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Resturant%20Image%20(1).png?alt=media&token=461162b1-686b-4b0e-a3ee-fae1cb8b5b33",
//                 "15 min away"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Card extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final String subtitle;

//   Card(this.text, this.icon, this.subtitle, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 25.0, bottom: 15),
//       child: Container(
//         width: 150,
//         height: 150,
//         padding: const EdgeInsets.all(15.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.5),
//           boxShadow: [
//             BoxShadow(
//                 offset: const Offset(10, 20),
//                 blurRadius: 10,
//                 spreadRadius: 0,
//                 color: Colors.grey.withOpacity(.05)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 70,
//             ),
//             Spacer(),
//             Text(text,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 )),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 12),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
