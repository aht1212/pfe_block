import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pfe_block/constants/private_key.dart';
import 'package:pfe_block/model/activite_model.dart';
import 'package:pfe_block/model/commerce_model.dart';
import 'package:pfe_block/model/contribuable_model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../model/agent_model.dart';
import '../model/typeCommerce_model.dart';

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
    _web3client = Web3Client(
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
    final contribuableAjouteEvent = _contract!.events[2];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: contribuableAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<Contribuable> contribuables = [];
    for (var log in logs) {
      final decoded =
          contribuableAjouteEvent.decodeResults(log.topics!, log.data!);
      Contribuable contribuable = Contribuable.fromEvent(decoded);
      contribuables.add(contribuable);
      print(contribuable.toJson());
    }
    isLoading = false;

    return contribuables;
  }

  Future<List<Commerce>> getCommerceAjouteEvents() async {
    isLoading = true;

    final commerceAjouteEvent = _contract!.events[1];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: commerceAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<Commerce> commerces = [];
    for (var log in logs) {
      final decoded = commerceAjouteEvent.decodeResults(log.topics!, log.data!);
      Commerce commerce = Commerce.fromEvent(decoded);
      commerces.add(commerce);
      print(commerce.toJson());
    }

    return commerces;
  }

  Future<List<TypeCommerce>> getTypeCommerceAjouteEvents() async {
    isLoading = true;

    final typeCommerceAjouteEvent = _contract!.events[3];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: typeCommerceAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);

    List<TypeCommerce> typeCommerces = [];
    for (var log in logs) {
      final decoded =
          typeCommerceAjouteEvent.decodeResults(log.topics!, log.data!);
      TypeCommerce typeCommerce = TypeCommerce.fromEvent(decoded);
      typeCommerces.add(typeCommerce);
      typeCommerce.toJson();
    }

    return typeCommerces;
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

      if (activite.droitFixeAnnuel != 0 && activite.id != 0) {
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
        .then((value) {
      print(value.toString());

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
    List<dynamic> params = [
      contribuable.ethAddress,
      contribuable.nif,
      contribuable.denomination,
      BigInt.from(contribuable.activitePrincipaleId),
      contribuable.nom,
      contribuable.prenom,
      contribuable.adresse,
      contribuable.email,
      BigInt.from(contribuable.contact),
      contribuable.valeurLocative,
      contribuable.typeContribuable,
      contribuable.dateCreation
    ];

    // Envoyez la transaction pour appeler la fonction
    _web3client!
        .sendTransaction(
            credential,
            Transaction.callContract(
                contract: _contract!,
                function: result,
                parameters: params,
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      isLoading = false;
    });
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

// Ajouter un type de commerce
  Future<void> ajouterTypeCommerce(
      TypeCommerce typeCommerce, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterTypeCommerce");
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
                parameters: [
                  typeCommerce.nom,
                  BigInt.from(typeCommerce.tarifAnnuel),
                  typeCommerce.description
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      return null;
    });
  }

// Supprimer un type de commerce
  Future<void> supprimerTypeCommerce(
      int idTypeCommerce, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerTypeCommerce");
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
                parameters: [BigInt.from(idTypeCommerce)],
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

    final function = _contract?.function("getTypeUtilisateur");
    var result = await _web3client!.call(
        contract: _contract!,
        function: function!,
        params: [adresse],
        atBlock: const BlockNum.current());
    return result[0].toString();
  }

  // ajouterActivite(Activite activite, EthereumAddress ethereumAddress) {
  //   // TODO: implement ajouterActivite

  // }

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
}
