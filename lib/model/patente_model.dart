import 'package:web3dart/web3dart.dart';

class Patente {
  int id;
  int contribuableId;
  int droitFixe;
  int droitProportionnel;
  int anneePaiement;
  int? sommePayee;
  bool estPayee;

  Patente({
    required this.id,
    required this.contribuableId,
    required this.droitFixe,
    required this.droitProportionnel,
    required this.anneePaiement,
    this.sommePayee,
    required this.estPayee,
  });

  factory Patente.fromJson(List<dynamic> json) {
    return Patente(
      id: json[0].toInt(),
      contribuableId: json[1].toInt(),
      droitFixe: json[2].toInt(),
      droitProportionnel: json[3].toInt(),
      anneePaiement: json[4].toInt(),
      estPayee: json[5],
    );
  }

  factory Patente.fromEvent(Map<String, dynamic> json) {
    return Patente(
      id: json['id'],
      contribuableId: json['contribuableId'],
      droitFixe: json['droitFixe'],
      droitProportionnel: json['droitProportionnel'],
      anneePaiement: json['anneePaiement'],
      estPayee: json['estPayee'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contribuableId': contribuableId,
      'droitFixe': droitFixe,
      'droitProportionnel': droitProportionnel,
      'anneePaiement': anneePaiement,
      'estPayee': estPayee,
    };
  }
}
