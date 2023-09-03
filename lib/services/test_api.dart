// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_web3/flutter_web3.dart';

// class MyContract {
//   final Contract _contract;
// final privatekey
//   MyContract(Web3Provider web3Provider)
//       : _contract = Contract.fromProvider(

//             jsonDecode(rootBundle.loadString('assets/TaxManagement.json')),
//             web3Provider);

//   Future<void> ajouterAgent(
//       String agent, int id, String nom, String prenom, String adresse, String email, int telephone) async {
//     await _contract.sendTransaction('ajouterAgent', [
//       EthereumAddress.fromHex(agent),
//       BigInt.from(id),
//       nom,
//       prenom,
//       adresse,
//       email,
//       BigInt.from(telephone)
//     ]);
//   }

//   Future<void> supprimerAgent(String agent) async {
//     await _contract.sendTransaction('supprimerAgent', [
//       EthereumAddress.fromHex(agent),
//     ]);
//   }

//   // Ajoutez des fonctions supplémentaires ici pour appeler d'autres fonctions de contrat
// }
