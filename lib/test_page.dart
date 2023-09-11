// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// enum UserType {
//   Contribuable,
//   AgentMairie,
//   Administration,
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gestion des utilisateurs',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connexion'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 navigateToHome(context, UserType.Contribuable);
//               },
//               child: Text('Connexion Contribuable'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 navigateToHome(context, UserType.AgentMairie);
//               },
//               child: Text('Connexion Agent Mairie'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 navigateToHome(context, UserType.Administration);
//               },
//               child: Text('Connexion Administration'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void navigateToHome(BuildContext context, UserType userType) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HomePage(userType: userType),
//       ),
//     );
//   }
// }

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

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import 'model/agent_model.dart';
import 'model/commerce_model.dart';
import 'model/contribuable_model.dart';
import 'model/typeCommerce_model.dart';
import 'services/tax_management_service.dart';

// Importez votre classe PatenteManagement ici
// import 'patente_management.dart';

class TestFunctionsScreen extends StatelessWidget {
  final PatenteManagement patenteManagement = PatenteManagement();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Tester les Fonctions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction ajouterAgent avec des valeurs par défaut
                patenteManagement.ajouterAgent(
                    Agent(
                      ethAddress: EthereumAddress.fromHex('0x123456789abcdef'),
                      nom: 'John',
                      prenom: 'Doe',
                      adresse: '123 Main St',
                      email: 'john.doe@example.com',
                      telephone: 123456789,
                    ),
                    EthereumAddress.fromHex('0xabcdef123456789'));
              },
              child: Text('Tester ajouterAgent'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction ajouterContribuable avec des valeurs par défaut
                patenteManagement.ajouterContribuable(
                    Contribuable(
                      ethAddress: EthereumAddress.fromHex('0x987654321abcdef'),
                      nom: 'Alice',
                      prenom: 'Smith',
                      adresse: '456 Elm St',
                      email: 'alice.smith@example.com',
                      telephone: 987654321,
                    ),
                    EthereumAddress.fromHex('0xfedcba987654321'));
              },
              child: Text('Tester ajouterContribuable'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction ajouterCommerce avec des valeurs par défaut
                patenteManagement.ajouterCommerce(
                    Commerce(
                      nom: 'Ma Boutique',
                      adresse: '789 Oak St',
                      contribuableAddress:
                          EthereumAddress.fromHex('0xabcdef123456789'),
                      chiffreAffairesAnnuel: 1000000,
                      typeCommerce: 1,
                      agentAddress:
                          EthereumAddress.fromHex('0xfedcba987654321'),
                    ),
                    EthereumAddress.fromHex('0x123456789abcdef'));
              },
              child: Text('Tester ajouterCommerce'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction ajouterTypeCommerce avec des valeurs par défaut
                patenteManagement.ajouterTypeCommerce(
                    TypeCommerce(
                      nom: 'Restaurant',
                      tarifAnnuel: 5000,
                      description: 'Restaurant Description',
                    ),
                    EthereumAddress.fromHex('0x987654321abcdef'));
              },
              child: Text('Tester ajouterTypeCommerce'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction supprimerContribuable avec des valeurs par défaut
                patenteManagement.supprimerContribuable(
                    EthereumAddress.fromHex('0xabcdef123456789'),
                    EthereumAddress.fromHex('0xfedcba987654321'));
              },
              child: Text('Tester supprimerContribuable'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction supprimerCommerce avec des valeurs par défaut
                patenteManagement.supprimerCommerce(
                    1, // Remplacez par l'ID du commerce à supprimer
                    EthereumAddress.fromHex('0x123456789abcdef'));
              },
              child: Text('Tester supprimerCommerce'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction supprimerTypeCommerce avec des valeurs par défaut
                patenteManagement.supprimerTypeCommerce(
                    1, // Remplacez par l'ID du type de commerce à supprimer
                    EthereumAddress.fromHex('0x987654321abcdef'));
              },
              child: Text('Tester supprimerTypeCommerce'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Appel de la fonction getTypeUtilisateur avec une adresse Ethereum de test
                final typeUtilisateur =
                    await patenteManagement.getTypeUtilisateur(
                        EthereumAddress.fromHex('0x123456789abcdef'));
                print('Type d\'utilisateur : $typeUtilisateur');
              },
              child: Text('Tester getTypeUtilisateur'),
            ),
          ],
        ),
      ),
    );
  }
}
