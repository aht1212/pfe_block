import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:pfe_block/home_page.dart';
import 'package:pfe_block/model/agent_model.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:web3dart/web3dart.dart';

import 'model/commerce_model.dart';
import 'model/contribuable_model.dart';
import 'model/typeCommerce_model.dart';

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
    _patenteManagement.setup();
  }

  Future<void> _checkConnection() async {
    if (ethereum == null) {
      print("connecter Metamask! ");
    } else {
      final isConnected = ethereum!.isConnected();
      final test = isConnected ? await ethereum!.requestAccount() : null;
      setState(() {
        _isConnected = isConnected;
        addressConnected = isConnected ? test!.first : "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ethereum!.onDisconnect((error) {
      setState(() {
        _checkConnection();
      });
    });
    return _isConnected
        ? MyHomeRealPage(addressConnected: addressConnected)
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
