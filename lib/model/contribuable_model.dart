import 'package:web3dart/web3dart.dart';

class Contribuable {
  int? id;
  EthereumAddress ethAddress;
  String nif;
  String denomination;
  int activitePrincipaleId;
  String nom;
  String prenom;
  String adresse;
  String email;
  int contact;
  int valeurLocative;
  int nombreEmployes;
  String anneeModification;
  int agentId;
  String typeContribuable;
  String dateCreation;
  bool? estEnregistre;

  Contribuable({
    this.id,
    required this.ethAddress,
    required this.nif,
    required this.denomination,
    required this.activitePrincipaleId,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.email,
    required this.contact,
    required this.valeurLocative,
    required this.nombreEmployes,
    required this.anneeModification,
    required this.agentId,
    required this.typeContribuable,
    required this.dateCreation,
    this.estEnregistre,
  });

  factory Contribuable.fromEvent(List<dynamic> json) {
    return Contribuable(
        id: json[0].toInt(),
        ethAddress: json[1],
        nif: json[2],
        denomination: json[3],
        activitePrincipaleId: json[4].toInt(),
        nom: json[5],
        prenom: json[6],
        adresse: json[7],
        email: json[8],
        contact: json[9].toInt(),
        valeurLocative: json[10].toInt(),
        nombreEmployes: json[11].toInt(),
        anneeModification: json[12],
        agentId: json[13].toInt(),
        typeContribuable: json[14],
        dateCreation: json[15],
        estEnregistre: json[16]);
  }

  factory Contribuable.fromJson(Map<String, dynamic> json) {
    return Contribuable(
        id: json["0"].toInt(),
        ethAddress: json["1"],
        nif: json["2"],
        denomination: json["3"],
        activitePrincipaleId: json["4"].toInt(),
        nom: json["5"],
        prenom: json["6"],
        adresse: json["7"],
        email: json["8"],
        contact: json["9"].toInt(),
        valeurLocative: json["10"].toInt(),
        nombreEmployes: json["11"].toInt(),
        anneeModification: json["12"],
        agentId: json["13"].toInt(),
        typeContribuable: json["14"],
        dateCreation: json["15"],
        estEnregistre: json["16"]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ethAddress': ethAddress.toString(),
        'nif': nif,
        'denomination': denomination,
        'activitePrincipaleId': activitePrincipaleId,
        'nom': nom,
        'prenom': prenom,
        'adresse': adresse,
        'email': email,
        'contact': contact,
        'valeurLocative': valeurLocative,
        'typeContribuable': typeContribuable,
        'dateCreation': dateCreation,
      };
}
