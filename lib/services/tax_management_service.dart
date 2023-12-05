import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pfe_block/auth_api.dart';
import 'package:pfe_block/constants/private_key.dart';
import 'package:pfe_block/model/activite_model.dart';
import 'package:pfe_block/model/commerce_model.dart';
import 'package:pfe_block/model/contribuable_model.dart';
import 'package:pfe_block/model/patente_model.dart';
import 'package:pfe_block/pages/admin/marchePage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../model/agent_model.dart';
import '../model/demandeOccupation_model.dart';
import '../model/demandeOccupation_model.dart';

class PatenteManagement {
  final String rpcUrl = defaultTargetPlatform == TargetPlatform.android
      ? "http://192.168.100.3:7545"
      : "http://127.0.0.1:7545";
  final String wsUrl = defaultTargetPlatform == TargetPlatform.android
      ? "http://192.168.100.3:7545"
      : "http://127.0.0.1:7545";
  final String privateKey =
      "0x6621c6728e92af21956c39b1d92e7ef56fb046df108fd6fc9a0c3eb491e8ac2c";

  Web3Client? _web3client;
  bool isLoading = false;

  String? abiCode;
  EthereumAddress? contractAddress;

  Credentials? credentials;

  DeployedContract? _contract;

  PatenteManagement() {
    setup();
  }

  setup() async {
    _web3client = defaultTargetPlatform == TargetPlatform.android
        ? Web3Client(
            rpcUrl,
            Client(),
          )
        : Web3Client(
            rpcUrl,
            Client(),
            socketConnector: () {
              return IOWebSocketChannel.connect(wsUrl).cast<String>();
            },
          );
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Utilisez 'await rootBundle.loadString' pour charger le JSON de manière synchrone.
    String abiStringFile = await rootBundle
        .loadString('smartContracts/build/contracts/TaxManagement.json');
    final jsonAbi = jsonDecode(abiStringFile);
    abiCode = jsonEncode(jsonAbi['abi']);
    contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(abiCode!, "TaxManagement"), contractAddress!);

    // for (var element in _contract!.events) {
    //   print(element.name);
    // }
  }

  Future<List<Agent>> getAgentAjouteEvents() async {
    isLoading = true;
    await setup();
    final agentFunction = _contract!.function("getAgents");
    BigInt cId = await _web3client!.getChainId();

    List<Agent> agents = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
        contract: _contract!,
        function: agentFunction,
        params: [],
        atBlock: BlockNum.current());
    List<dynamic> agentsCall = contractCall[0];
    for (var element in agentsCall) {
      Agent a = Agent.fromEvent(element);

      if (a.estEnregistrer!) {
        agents.add(a);
      }
    }
    // agents = contractCall.map((e) => null)
    return agents;
  }

  Future<List<Contribuable>> getContribuableAjouteEvents() async {
    isLoading = true;
    await setup();
    final contribuableFunction = _contract!.function("getContribuables");
    BigInt cId = await _web3client!.getChainId();

    List<Contribuable> contribuables = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
        contract: _contract!,
        function: contribuableFunction,
        params: [],
        atBlock: BlockNum.current());
    List<dynamic> contribuablesCall = contractCall[0];
    for (var element in contribuablesCall) {
      Contribuable a = Contribuable.fromEvent(element);

      if (a.estEnregistre!) {
        contribuables.add(a);
      }
    }
    // contribuables = contractCall.map((e) => null)
    return contribuables;
  }

  Future<Contribuable?> getContribuable(int contribuableId) async {
    isLoading = true;
    await setup();
    final contribuableFunction = _contract!.function("contribuables");
    BigInt cId = await _web3client!.getChainId();

    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List<dynamic> contractCall = await _web3client!.call(
        contract: _contract!,
        function: contribuableFunction,
        params: [BigInt.from(contribuableId)],
        atBlock: BlockNum.current());

    print(contractCall);

    Contribuable contribuables = Contribuable.fromEvent(contractCall);

    // contribuables = contractCall.map((e) => null)
    return contribuables;
  }

//liste des marchés
  Future<List<Marche>> getMarcheAjouteEvents() async {
    isLoading = true;
    await setup();
    final marcheFunction = _contract!.function("getMarches");
    BigInt cId = await _web3client!.getChainId();

    List<Marche> marches = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
        contract: _contract!,
        function: marcheFunction,
        params: [],
        atBlock: BlockNum.current());
    List<dynamic> marchesCall = contractCall[0];
    for (var element in marchesCall) {
      Marche a = Marche.fromEvent(element);

      marches.add(a);
    }
    // marches = contractCall.map((e) => null)
    return marches;
  }

//ajouter demandeoccupation
  Future<void> ajouterDemandeOccupation(DemandeOccupation demandeoccupation,
      EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("creerDemandeOccupation");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";

    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  demandeoccupation.idContribuable,
                  demandeoccupation.idMarche,
                  demandeoccupation.dateDebut,
                  demandeoccupation.dateFin,
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) async {
      print(value.toString());

      // final adresseEth = querySnapshot.docs.first['adresseEth'];

      isLoading = false;
      return null;
    });
    await setup();
  }

  Future<void> validerDemandeOccupation(DemandeOccupation demandeoccupation,
      EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("validerDemandeOccupation");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";

    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  demandeoccupation.idoccupation,
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) async {
      print(value.toString());

      // final adresseEth = querySnapshot.docs.first['adresseEth'];

      isLoading = false;
      return null;
    });
    await setup();
  }

  Future<List<DemandeOccupation>> getDemandeOccupationAjouteEvents() async {
    isLoading = true;

    final demandeoccupationAjouteEvent = _contract!.events[0];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: demandeoccupationAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<DemandeOccupation> demandeoccupations = [];
    for (var log in logs) {
      final decoded =
          demandeoccupationAjouteEvent.decodeResults(log.topics!, log.data!);
      DemandeOccupation demandeoccupation =
          DemandeOccupation.fromContract(decoded);
      demandeoccupations.add(demandeoccupation);
      print(demandeoccupation.toString());
    }

    return demandeoccupations;
  }

  Future<List<DemandeOccupationValidee>>
      getDemandeOccupationValideeEvents() async {
    isLoading = true;

    final demandeOccupationAjouteEvent = _contract!.events[1];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: demandeOccupationAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<DemandeOccupationValidee> demandeOccupations = [];
    for (var log in logs) {
      final decoded =
          demandeOccupationAjouteEvent.decodeResults(log.topics!, log.data!);
      DemandeOccupationValidee demandeOccupation =
          DemandeOccupationValidee.fromEvent(decoded);
      demandeOccupations.add(demandeOccupation);
      print(demandeOccupation.toString());
    }

    return demandeOccupations;
  }

  Future<List<Activite>> getActivites() async {
    isLoading = true;
    await setup();
    final activiteFunction = _contract!.function("getActivitesPrincipales");
    BigInt cId = await _web3client!.getChainId();

    List<Activite> activites = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
      contract: _contract!,
      function: activiteFunction,
      params: [],
      atBlock: BlockNum.current(),
    );

    for (var element in contractCall[0]) {
      Activite activite = Activite.fromEvent(element);

      if (activite.droitFixeAnnuel != 0 && activite.nom != "") {
        activites.add(activite);
      }
    }

    isLoading = false;
    return activites;
  }

//ajouter agent
  Future<void> ajouterAgent(
      Agent agent, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterAgent");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  agent.ethAddress,
                  agent.nom,
                  agent.prenom,
                  agent.adresse,
                  agent.email,
                  BigInt.from(agent.telephone)
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) async {
      print(value.toString());

      register(
        agent.email,
        agent.nom + agent.prenom,
      );

      // final adresseEth = querySnapshot.docs.first['adresseEth'];

      isLoading = false;
      return null;
    });
    await setup();
  }

  //modifier agent
  Future<void> modifierAgent(
      Agent agent, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("modifierAgent");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  agent.ethAddress,
                  agent.nom,
                  agent.prenom,
                  agent.adresse,
                  agent.email,
                  BigInt.from(agent.telephone)
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());

      isLoading = false;
      return null;
    });
    await setup();
  }

  // Supprimer un contribuable
  Future<void> supprimerAgent(
      EthereumAddress agent, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerAgent");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [agent],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      return null;
    });
    await setup();
    isLoading = false;
  }

  // Ajouter un contribuable
  Future<void> ajouterContribuable(
      Contribuable contribuable, EthereumAddress addressExpediteur) async {
    isLoading = true;
    await setup();
    // Récupérez l'objet ContractFunction pour la fonction "ajouterContribuable"
    var result = _contract!.function("ajouterContribuable");

    // Récupérez la chaîne d'identifiant de chaîne Ethereum
    BigInt cId = await _web3client!.getChainId();

    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });

    // Créez un objet Credentials à partir de la clé privée
    Credentials credential = EthPrivateKey.fromHex(privateKey);

    // Préparez les paramètres pour la fonction "ajouterContribuable"
    // List<dynamic> params = [];

    // Envoyez la transaction pour appeler la fonction
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  contribuable.ethAddress,
                  contribuable.nif,
                  contribuable.denomination,
                  BigInt.from(contribuable.activitePrincipaleId),
                  contribuable.nom,
                  contribuable.prenom,
                  contribuable.adresse,
                  contribuable.email,
                  BigInt.from(contribuable.contact),
                  contribuable.typeContribuable,
                  contribuable.dateCreation,
                  BigInt.from(contribuable.valeurLocative),
                  BigInt.from(contribuable.nombreEmployes),
                  contribuable.anneeModification,
                  BigInt.from(contribuable.agentId)
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      isLoading = false;
    });
    await register(
      contribuable.email,
      contribuable.nom + contribuable.prenom,
    );
  }

// Supprimer un contribuable
  Future<void> supprimerContribuable(
      EthereumAddress contribuable, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerContribuable");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [contribuable],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      return null;
    });
  }

// // Ajouter un type de commerce
//   Future<void> ajouterDemandeOccupation(
//       DemandeOccupation demandeOccupation, EthereumAddress addressExpediteur) async {
//     isLoading = true;

//     var result = _contract!.function("ajouterDemandeOccupation");
//     BigInt cId = await _web3client!.getChainId();
//     String privateKey = "";
//     ethereumAccounts.forEach((key, value) {
//       if (key == addressExpediteur.hexEip55) {
//         privateKey = value;
//       }
//     });
//     Credentials credential = EthPrivateKey.fromHex(privateKey);
//     _web3client!
//         .sendTransaction(
//             credential,
//             Transaction.callContract(
//                 contract: _contract!,
//                 function: result,
//                 parameters: [
//                   demandeOccupation.nom,
//                   BigInt.from(demandeOccupation.tarifAnnuel),
//                   demandeOccupation.description
//                 ],
//                 from: addressExpediteur),
//             chainId: cId.toInt())
//         .then((value) {
//       print(value.toString());
//       return null;
//     });
//   }

// Supprimer un type de commerce
  Future<void> supprimerDemandeOccupation(
      int idDemandeOccupation, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerDemandeOccupation");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [BigInt.from(idDemandeOccupation)],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      return null;
    });
  }

  Future<String> getTypeUtilisateur(EthereumAddress adresse) async {
    isLoading = true;

    await setup();

    final function = _contract!.function("getTypeUtilisateur");

    BigInt cId = await _web3client!.getChainId();

    var result = await _web3client!.call(
        contract: _contract!,
        function: function,
        params: [adresse],
        atBlock: const BlockNum.current());
    return result[0].toString();
  }

  // ajouterActivite(Activite activite, EthereumAddress ethereumAddress) {
  //   // TODO: implement ajouterActivite

  // }
  Future<List<Patente>> getPatentesNonPayer() async {
    isLoading = true;
    await setup();
    final patenteFunction = _contract!.function("getPatentesNonPayer");
    BigInt cId = await _web3client!.getChainId();

    List<Patente> patentes = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
      contract: _contract!,
      function: patenteFunction,
      params: [],
      atBlock: BlockNum.current(),
    );

    for (var element in contractCall[0]) {
      Patente patente = Patente.fromJson(element);

      patentes.add(patente);
    }

    isLoading = false;
    return patentes;
  }

  Future<List<Patente>> getPatentesPayer() async {
    isLoading = true;
    await setup();
    final patenteFunction = _contract!.function("getPatentesNonPayer");
    BigInt cId = await _web3client!.getChainId();

    List<Patente> patentes = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
      contract: _contract!,
      function: patenteFunction,
      params: [],
      atBlock: BlockNum.current(),
    );

    for (var element in contractCall[0]) {
      Patente patente = Patente.fromJson(element);

      patentes.add(patente);
    }

    isLoading = false;
    return patentes;
  }

  Future<List<Patente>> getPatentesByContribuable(
      EthereumAddress _contribuablesAddress) async {
    isLoading = true;
    await setup();
    final patenteFunction = _contract!.function("getPatenteByContribuable");
    BigInt cId = await _web3client!.getChainId();

    List<Patente> patentes = [];
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    List contractCall = await _web3client!.call(
      contract: _contract!,
      function: patenteFunction,
      params: [_contribuablesAddress],
      atBlock: BlockNum.current(),
    );

    for (var element in contractCall[0]) {
      Patente patente = Patente.fromJson(element);

      patentes.add(patente);
    }

    isLoading = false;
    return patentes;
  }

  Future<void> ajouterPatente(int _contribuableId, int _anneePaiement,
      EthereumAddress addressExpediteur) async {
    isLoading = true;
    await setup();
    var result = _contract!.function("creerPatente");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  BigInt.from(_contribuableId),
                  BigInt.from(_anneePaiement),
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());

      isLoading = false;
      return null;
    });
    await setup();
  }

  Future<List<Patente>> getPatenteValideeEvents() async {
    isLoading = true;

    final patenteAjouteEvent = _contract!.events[2];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: patenteAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<Patente> patentes = [];
    for (var log in logs) {
      final decoded = patenteAjouteEvent.decodeResults(log.topics!, log.data!);
      // Patente patente = Patente.fromJson(decoded);
      // patentes.add(patente);
      // print(patente.toString());
    }

    return patentes;
  }

  Future<void> ajouterActivite(
      Activite activite, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterActivitePrincipale");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  activite.nom,
                  BigInt.from(activite.droitFixeAnnuel),
                  activite.description,
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());

      isLoading = false;
      return null;
    });
    await setup();
  }

  Future<void> modifierActivite(
      Activite activite, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("modifierActivitePrincipale");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  BigInt.from(activite.id!),
                  activite.nom,
                  activite.droitFixeAnnuel,
                  activite.description
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());

      isLoading = false;
      return null;
    });
    await setup();
  }

  Future<void> supprimerActivite(
      Activite activite, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerActivitePrincipale");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [BigInt.from(activite.id!)],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      return null;
    });
    await setup();
    isLoading = false;
  }

  Future<void> ajouterMarche(
      Marche marche, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterMarche");
    BigInt cId = await _web3client!.getChainId();
    String privateKey = "";
    ethereumAccounts.forEach((key, value) {
      if (key == addressExpediteur.hexEip55) {
        privateKey = value;
      }
    });
    Credentials credential = EthPrivateKey.fromHex(privateKey);
    await _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: [
                  marche.nom,
                  BigInt.from(marche.nombrePlaces),
                  BigInt.from(marche.prixPlace),
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());

      isLoading = false;
      return null;
    });
    await setup();
  }
}
