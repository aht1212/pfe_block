import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:pfe_block/model/agent_model.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isConnected = false;
  String addressConnected = "";

  PatenteManagement _patenteManagement = PatenteManagement();
  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      final isConnected = ethereum!.isConnected();
      final test = isConnected ? await ethereum!.requestAccount() : null;

      setState(() {
        _isConnected = isConnected;
        addressConnected = isConnected ? test!.first : "";
      });
    } catch (e) {
      showAboutDialog(context: context, children: [Text("Error : $e")]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () async {
                    ethereum!.removeAllListeners();
                  },
                  icon: Icon(Icons.logout_outlined)),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await _patenteManagement.ajouterAgent(
                    Agent(
                        // id: 0,
                        ethAddress: EthereumAddress.fromHex(
                            "0xFF95aBDc67003C0Ef7fedb95BfAFf9e0d38357BA"),
                        nom: "Dupont",
                        prenom: "Jean",
                        adresse: "1 Rue du commerce ",
                        email: "test@email.com",
                        telephone: 909092882),
                    EthereumAddress.fromHex(addressConnected));
              },
              child: Icon(Icons.add),
            ),
            body: Column(
              children: [
                Center(
                  child: Text(
                    'Addresse : ${addressConnected}',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _patenteManagement.getAgentAjouteEvents();
                    await _patenteManagement.getCommerceAjouteEvents();

                    await _patenteManagement.getContribuableAjouteEvents();

                    await _patenteManagement.getTypeCommerceAjouteEvents();
                  },
                  child: Text('Se connecter à MetaMask'),
                )
              ],
            ))
        : Scaffold(
            body: ElevatedButton(
            onPressed: () async {
              // final ethereum = ethereum;
              if (ethereum != null) {
                try {
                  // Demande à l'utilisateur de se connecter à MetaMask
                  await ethereum!.requestAccount();

                  _checkConnection();
                } catch (ex) {
                  print('Erreur de connexion à MetaMask: $ex');
                }
              }
            },
            child: Text('Se connecter à MetaMask'),
          ));
  }
}
