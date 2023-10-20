// Modèle pour stocker les informations du contribuable
import 'package:web3dart/web3dart.dart';

class Contribuable {
  int? id;
  EthereumAddress ethAddress;
  String nom;
  String prenom;
  String adresse;
  String email;
  int telephone;
  bool? estEnregistrer;

  Contribuable(
      {this.id,
      required this.ethAddress,
      required this.nom,
      required this.prenom,
      required this.adresse,
      required this.email,
      required this.telephone,
      this.estEnregistrer});

  factory Contribuable.fromEvent(List<dynamic> json) {
    return Contribuable(
        id: json[0].toInt(),
        ethAddress: json[1],
        nom: json[2],
        prenom: json[3],
        adresse: json[4],
        email: json[5],
        telephone: json[6].toInt(),
        estEnregistrer: json[7]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'prenom': prenom,
        'adresse': adresse,
        'email': email,
        'telephone': telephone,
      };
}
