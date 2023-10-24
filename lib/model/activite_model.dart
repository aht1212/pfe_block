// Modèle pour stocker les informations des activites

class Activite {
  int? id;
  String nom;
  String description;
  int droitFixeAnnuel;
  bool? estEnregistrer;

  Activite(
      {this.id,
      required this.nom,
      required this.description,
      required this.droitFixeAnnuel,
      this.estEnregistrer});

  factory Activite.fromEvent(List<dynamic> json) {
    return Activite(
        id: json[0].toInt(),
        nom: json[1],
        description: json[3],
        droitFixeAnnuel: json[2].toInt(),
        estEnregistrer: json[4]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'description': description,
        'droitfixeAnnuel': droitFixeAnnuel,
      };
}
