class Taxe {
  final int id;
  final int idCommerce;
  final int mois;
  final int annee;
  final int montant;
  final bool estPayee;
  final int count;

  Taxe({
    required this.id,
    required this.idCommerce,
    required this.mois,
    required this.annee,
    required this.montant,
    required this.estPayee,
    required this.count,
  });
}
