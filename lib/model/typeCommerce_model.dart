// Modèle pour stocker les informations des types de commerce

class TypeCommerce {
  int id;
  String nom;
  int tarifAnnuel;
  String description;

  TypeCommerce({
    required this.id,
    required this.nom,
    required this.tarifAnnuel,
    required this.description,
  });

  factory TypeCommerce.fromEvent(List<dynamic> json) {
    return TypeCommerce(
      id: json[0].toInt(),
      nom: json[1],
      tarifAnnuel: json[2].toInt(),
      description: json[3],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'tarifAnnuel': tarifAnnuel,
        'description': description,
      };
}
