import 'package:flutter/material.dart';

enum TypeContribuable {
  particulier,
  entreprise,
}

class Contribuable {
  final String nom;
  final String prenom;
  final String adresse;
  final String telephone;
  final TypeContribuable type;

  Contribuable({
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
    required this.type,
  });
}

class ContribuablesListPage extends StatelessWidget {
  final List<Contribuable> contribuables = [
    Contribuable(
      nom: 'Doe',
      prenom: 'John',
      adresse: '123 rue Principale',
      telephone: '555-555-5555',
      type: TypeContribuable.particulier,
    ),
    Contribuable(
      nom: 'Smith',
      prenom: 'Jane',
      adresse: '456 rue Secondaire',
      telephone: '555-555-5555',
      type: TypeContribuable.particulier,
    ),
    Contribuable(
      nom: 'ACME Inc.',
      prenom: '',
      adresse: '789 rue Tertiaire',
      telephone: '555-555-5555',
      type: TypeContribuable.entreprise,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Contribuables'),
      ),
      body: ListView.separated(
        itemCount: contribuables.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          Contribuable contribuable = contribuables[index];
          return ListTile(
            leading: _buildAvatar(contribuable.type, context),
            title: Text('${contribuable.nom} ${contribuable.prenom}'),
            subtitle: Text(contribuable.adresse),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // TODO: Ajouter la logique pour afficher les détails du contribuable sélectionné.
            },
          );
        },
      ),
    );
  }

  Widget _buildAvatar(TypeContribuable type, BuildContext context) {
    if (type == TypeContribuable.particulier) {
      return CircleAvatar(
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Icon(
          Icons.business,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      );
    }
  }
}
