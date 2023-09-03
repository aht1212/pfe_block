import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfe_block/pages/admin_screen.dart';
import 'package:pfe_block/pages/agent_page.dart';
import 'package:pfe_block/pages/contribuable_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<QuerySnapshot> userSnapshot =
      FirebaseFirestore.instance.collection("users").snapshots();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: userSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.requireData;

            String? userType;

            userType =
                data.docs.where((e) => e['email'] == user.email).first['type'];

            if (userType == "Contribuable") {
              // Interface spécifique au contribuable
              return ContribuableScreen();
              // ... Ajoutez ici les widgets spécifiques au contribuable
            } else if (userType == "Agent") {
              // Interface spécifique à l'agent de la mairie
              AgentScreen();
              // ... Ajoutez ici les widgets spécifiques à l'agent de la mairie
            } else if (userType == "Admin") {
              // Interface spécifique à l'administration
              return AdminScreen();
              // ... Ajoutez ici les widgets spécifiques à l'administration
            }
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Something is wrong !!"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Center(
              child: Text("Something goes really wrong!!"),
            );
          }
        }
        //This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

enum UserType {
  Contribuable,
  AgentMairie,
  Administration,
}

// class HomePage extends StatelessWidget {
//   final UserType userType;

//   HomePage({required this.userType});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accueil'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Bienvenue',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Type d\'utilisateur: ${getUserTypeString()}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 16),
//             if (userType == UserType.Contribuable) ...[
//               // Interface spécifique au contribuable
//               Text('Interface Contribuable'),
//               // ... Ajoutez ici les widgets spécifiques au contribuable
//             ] else if (userType == UserType.AgentMairie) ...[
//               // Interface spécifique à l'agent de la mairie
//               Text('Interface Agent Mairie'),
//               // ... Ajoutez ici les widgets spécifiques à l'agent de la mairie
//             ] else if (userType == UserType.Administration) ...[
//               // Interface spécifique à l'administration
//               Text('Interface Administration'),
//               // ... Ajoutez ici les widgets spécifiques à l'administration
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   String getUserTypeString() {
//     switch (userType) {
//       case UserType.Contribuable:
//         return 'Contribuable';
//       case UserType.AgentMairie:
//         return 'Agent Mairie';
//       case UserType.Administration:
//         return 'Administration';
//       default:
//         return 'Inconnu';
//     }
//   }
// }
