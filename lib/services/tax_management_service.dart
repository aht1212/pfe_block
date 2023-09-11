import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pfe_block/constants/private_key.dart';
import 'package:pfe_block/model/commerce_model.dart';
import 'package:pfe_block/model/contribuable_model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../model/agent_model.dart';
import '../model/typeCommerce_model.dart';

class PatenteManagement {
  final String rpcUrl = "http://127.0.0.1:7545";
  final String wsUrl = "ws://127.0.0.1:7545";
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

    final agentAjouteEvent = _contract!.events[0];
    final filter = FilterOptions.events(
      contract: _contract!,
      event: agentAjouteEvent,
      fromBlock: BlockNum.genesis(),
      toBlock: BlockNum.current(),
    );
    final logs = await _web3client!.getLogs(filter);
// Traiter les logs récupérés
    List<Agent> agents = [];
    for (var log in logs) {
      final decoded = agentAjouteEvent.decodeResults(log.topics!, log.data!);
      Agent agent = Agent.fromEvent(decoded);
      agents.add(agent);

      print(agent.toJson());
    }
    return agents;
  }

  Future<List<Contribuable>> getContribuableAjouteEvents() async {
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
    isLoading = true;

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
    _web3client!
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
      return null;
    });
    // } catch (e) {
    //   print(e);
    // }
  }

  // Ajouter un contribuable
  Future<void> ajouterContribuable(
      Contribuable contribuable, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterContribuable");
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
                  contribuable.ethAddress,
                  contribuable.nom,
                  contribuable.prenom,
                  contribuable.adresse,
                  contribuable.email,
                  BigInt.from(contribuable.telephone)
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      return null;
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

// Ajouter un commerce
  Future<void> ajouterCommerce(
      Commerce commerce, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("ajouterCommerce");
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
                  commerce.nom,
                  commerce.adresse,
                  commerce.contribuableAddress,
                  BigInt.from(commerce.chiffreAffairesAnnuel),
                  BigInt.from(commerce.typeCommerce),
                  // addressExpediteur,
                ],
                from: addressExpediteur),
            chainId: cId.toInt())
        .then((value) {
      print(value.toString());
      return null;
    });
  }

// Supprimer un commerce
  Future<void> supprimerCommerce(
      int idCommerce, EthereumAddress addressExpediteur) async {
    isLoading = true;

    var result = _contract!.function("supprimerCommerce");
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
                parameters: [BigInt.from(idCommerce)],
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
}
