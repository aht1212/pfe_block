// Modèle pour stocker les informations du commerce
import 'package:web3dart/web3dart.dart';

class Commerce {
  int? id;
  String nom;
  String adresse;
  EthereumAddress contribuableAddress;
  int chiffreAffairesAnnuel;
  int typeCommerce;
  EthereumAddress agentAddress;

  Commerce({
     this.id,
    required this.nom,
    required this.adresse,
    required this.contribuableAddress,
    required this.chiffreAffairesAnnuel,
    required this.typeCommerce,
    required this.agentAddress,
  });

  factory Commerce.fromEvent(List<dynamic> json) {
    return Commerce(
      id: json[0].toInt(),
      nom: json[1],
      adresse: json[2],
      contribuableAddress: json[3],
      chiffreAffairesAnnuel: json[4].toInt(),
      typeCommerce: json[5].toInt(),
      agentAddress: json[6],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'adresse': adresse,
        'contribuableAddress': contribuableAddress.toString(),
        'chiffreAffairesAnnuel': chiffreAffairesAnnuel,
        'typeCommerce': typeCommerce,
        'agentAddress': agentAddress.toString(),
      };
}
