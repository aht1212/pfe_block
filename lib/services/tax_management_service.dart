import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
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

    for (var element in _contract!.events) {
      print(element.name);
    }
  }

  Future<List<Agent>> getAgentAjouteEvents() async {
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

    return contribuables;
  }

  Future<List<Commerce>> getCommerceAjouteEvents() async {
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
    var result = _contract!.function("ajouterAgent");
    _web3client!.call(
        contract: _contract!,
        function: result,
        params: [
          agent.ethAddress,
          agent.nom,
          agent.prenom,
          agent.adresse,
          agent.email,
          agent.telephone
        ],
        sender: addressExpediteur);
    // } catch (e) {
    //   print(e);
    // }
  }
}
