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
      // sommePayee: json[5] == null ? null : json[5].,
      estPayee: json[5],
    );
  }

  factory Patente.fromEvent(List<dynamic> json) {
    return Patente(
      id: json[0].toInt(),
      contribuableId: json[1].toInt(),
      droitFixe: json[2].toInt(),
      droitProportionnel: json[3].toInt(),
      anneePaiement: json[4].toInt(),
      sommePayee: json[5] == null ? 0 : json[5].toInt(),
      estPayee: json[6],
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
