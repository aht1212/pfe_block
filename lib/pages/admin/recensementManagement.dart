import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/contribuable_model.dart';
import '../../services/tax_management_service.dart';

class RecensementManagementScreen extends StatefulWidget {
  const RecensementManagementScreen({super.key});

  @override
  State<RecensementManagementScreen> createState() =>
      _RecensementManagementScreenState();
}

class _RecensementManagementScreenState
    extends State<RecensementManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return RegisterContribuableForm();
  }
}

class RegisterContribuableForm extends StatefulWidget {
  @override
  _RegisterContribuableFormState createState() =>
      _RegisterContribuableFormState();
}

class _RegisterContribuableFormState extends State<RegisterContribuableForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _nif = '';
  String _denomination = '';
  int _activitePrincipaleId = 0;
  String _prenom = '';
  String _adresse = '';
  String _email = '';
  int _contact = 0;
  String _typeContribuable = '';
  int _valeurLocative = 0;
  PatenteManagement patenteManagement = PatenteManagement();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du contribuable'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom du contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'NIF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le NIF';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nif = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dénomination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la dénomination du contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _denomination = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration:
                    InputDecoration(labelText: "ID de l'activité principal"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir l'ID de l'activité principale";
                  }
                  return null;
                },
                onSaved: (value) {
                  _activitePrincipaleId = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prénom du contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prenom = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir l'adresse du contribuable";
                  }
                  return null;
                },
                onSaved: (value) {
                  _adresse = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir l'email du contribuable";
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le contact du contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contact = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type de contribuable'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le type de contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _typeContribuable = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valeur locative'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la valeur locative du contribuable';
                  }
                  return null;
                },
                onSaved: (value) {
                  _valeurLocative = int.parse(value!);
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  // await patenteManagement.getAllContribuables();
                  await patenteManagement.getContribuableAjouteEvents();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Appel de la fonction pour enregistrer le contribuable en utilisant Web3dart
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> enregistrerContribuable(
    EthereumAddress ethAddress,
    String name,
    String nif,
    String denomination,
    int activitePrincipaleId,
    String prenom,
    String adresse,
    String email,
    int contact,
    String typeContribuable,
    int valeurLocative,
  ) async {
    // Connexion au nœud Ethereum en utilisant Web3dart

    // Appel de la fonction pour enregistrer le contribuable
    patenteManagement.ajouterContribuable(
        Contribuable(
          ethAddress: ethAddress,
          nom: name,
          nif: nif,
          denomination: denomination,
          activitePrincipaleId: activitePrincipaleId,
          prenom: prenom,
          adresse: adresse,
          email: email,
          contact: contact,
          typeContribuable: typeContribuable,
          valeurLocative: valeurLocative,
          dateCreation: DateTime.now().toString(),
        ),
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
  }
}
