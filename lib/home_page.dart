import 'package:pfe_block/pages/admin_screen.dart';
import 'package:pfe_block/pages/agent_page.dart';
import 'package:pfe_block/pages/contribuable_page.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';

class MyHomeRealPage extends StatefulWidget {
  const MyHomeRealPage({
    super.key,
    required this.addressConnected,
  });
  final String addressConnected;
  @override
  State<MyHomeRealPage> createState() => _MyHomeRealPageState();
}

class _MyHomeRealPageState extends State<MyHomeRealPage> {
  PatenteManagement patenteManagem = PatenteManagement();
  String userType = "";
  late Future<String> typeUser;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // getUserType();
  // }

  Future<String> getUserType() async {
    EthereumAddress address = EthereumAddress.fromHex(widget.addressConnected);
    await patenteManagem.getActivites();
    print("lol");
    String result = await patenteManagem.getTypeUtilisateur(address);
    setState(() {
      userType = result;
    });
    // print(userType);
    return result;
  }

  @override
  void initState() {
    super.initState();
    typeUser = getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: typeUser,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final String data = snapshot.requireData;

                  userType = data;

                  if (userType == "Contribuable") {
                    // Interface spécifique au contribuable
                    return ContribuableScreen();
                    // ... Ajoutez ici les widgets spécifiques au contribuable
                  } else if (userType == "Agent") {
                    // Interface spécifique à l'agent de la mairie
                    return AgentScreen();
                    // ... Ajoutez ici les widgets spécifiques à l'agent de la mairie
                  } else if (userType == "Admin") {
                    // Interface spécifique à l'administration
                    return AdminScreen();
                    // ... Ajoutez ici les widgets spécifiques à l'administration
                  } else {
                    return Scaffold(
                      body: Center(child: Text("error")),
                    );
                  }
                }
                if (snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              }
              //This trailing comma makes auto-formatting nicer for build methods.
              ),
        ),
      ],
    );
  }
}

enum UserType {
  Contribuable,
  Agent,
  Admin,
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
