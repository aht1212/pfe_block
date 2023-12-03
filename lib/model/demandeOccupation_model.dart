// Modèle pour stocker les informations des types de commerce

import 'package:web3dart/web3dart.dart';

class DemandeOccupation {
  int? idoccupation;
  int idMarche;
  String dateDebut;
  String dateFin;
  int idContribuable;
  bool estValidee;

  DemandeOccupation({
    this.idoccupation,
    required this.idMarche,
    required this.dateDebut,
    required this.dateFin,
    required this.idContribuable,
    required this.estValidee,
  });

  factory DemandeOccupation.fromContract(List<dynamic> json) {
    return DemandeOccupation(
      idoccupation: json[0].toInt(),
      idMarche: json[1],
      dateDebut: json[2],
      dateFin: json[3],
      idContribuable: json[4].toInt(),
      estValidee: json[5],
    );
  }
  factory DemandeOccupation.fromEvent(List<dynamic> json) {
    return DemandeOccupation(
      idoccupation: json[0].toInt(),
      idMarche: json[1],
      dateDebut: json[2],
      dateFin: json[3],
      idContribuable: json[4].toInt(),
      estValidee: false,
    );
  }
}

class DemandeOccupationValidee {
  int idoccupation;
  int idMarche;
  int place;
  String dateDebut;
  String dateFin;
  int idContribuable;
  EthereumAddress? addressAgent;

  DemandeOccupationValidee({
    required this.idoccupation,
    required this.idMarche,
    required this.place,
    required this.dateDebut,
    required this.dateFin,
    required this.idContribuable,
    // required this.addressAgent,
    this.addressAgent,
  });

  factory DemandeOccupationValidee.fromEvent(List<dynamic> json) {
    return DemandeOccupationValidee(
      idoccupation: json[0].toInt(),
      idMarche: json[1],
      place: json[2].toInt(),
      dateDebut: json[3],
      dateFin: json[4],
      idContribuable: json[5].toInt(),
      addressAgent: EthereumAddress.fromHex(json[6]),
    );
  }
}
