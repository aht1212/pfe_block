import 'package:flutter/material.dart';

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
    return RegisterCommerceForm();
  }
}

// class PatenteManagementScreen extends StatefulWidget {
//   @override
//   _PatenteManagementScreenState createState() =>
//       _PatenteManagementScreenState();
// }

// class _PatenteManagementScreenState extends State<PatenteManagementScreen> {
//   final PatenteManagement _patenteManagement = PatenteManagement();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _chiffreAffairesController =
//       TextEditingController();
//   final TextEditingController _classificationController =
//       TextEditingController();
//   final TextEditingController _zoneController = TextEditingController();
//   final TextEditingController _commerceIDController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion de la Patente'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Enregistrer un Commerce',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Nom du Commerce'),
//             ),
//             TextFormField(
//               controller: _chiffreAffairesController,
//               decoration: InputDecoration(labelText: 'Chiffre d\'Affaires'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _classificationController,
//               decoration: InputDecoration(labelText: 'Classification (8 ou 9)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _zoneController,
//               decoration:
//                   InputDecoration(labelText: 'Zone (Zone1, Zone2, ou Zone3)'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // _patenteManagement.registerCommerce(
//                 //   _nameController.text,
//                 //   int.parse(_chiffreAffairesController.text),
//                 //   int.parse(_classificationController.text),
//                 //   _zoneController.text,
//                 // );
//               },
//               child: Text('Enregistrer'),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Payer la Patente',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _commerceIDController,
//               decoration: InputDecoration(labelText: 'ID du Commerce'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _amountController,
//               decoration: InputDecoration(labelText: 'Montant à Payer'),
//               keyboardType: TextInputType.number,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _patenteManagement.payPatente(
//                   int.parse(_commerceIDController.text),
//                   int.parse(_amountController.text),
//                 );
//               },
//               child: Text('Payer'),
//             ),
//             // Ajoutez ici d'autres fonctionnalités pour mettre à jour ou supprimer les commerces
//           ],
//         ),
//       ),
//     );
//   }
// }

class RegisterCommerceForm extends StatefulWidget {
  @override
  _RegisterCommerceFormState createState() => _RegisterCommerceFormState();
}

class _RegisterCommerceFormState extends State<RegisterCommerceForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _physicalAddress = '';
  String _latitude = '';
  String _longitude = '';
  int _chiffreAffaires = 0;
  int _classification = 0;
  int _zone = 0;
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
                decoration: InputDecoration(labelText: 'Nom du commerce'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom du commerce';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse physique'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir l\'adresse physique du commerce';
                  }
                  return null;
                },
                onSaved: (value) {
                  _physicalAddress = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  // Ajoutez ici des validations supplémentaires si nécessaire
                  return null;
                },
                onSaved: (value) {
                  _latitude = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  // Ajoutez ici des validations supplémentaires si nécessaire
                  return null;
                },
                onSaved: (value) {
                  _longitude = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Chiffre d\'affaires'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le chiffre d\'affaires';
                  }
                  return null;
                },
                onSaved: (value) {
                  _chiffreAffaires = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Classification (8ème ou 9ème classe)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la classification';
                  }
                  return null;
                },
                onSaved: (value) {
                  _classification = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(value: 0, child: Text('Zone 1')),
                  DropdownMenuItem(value: 1, child: Text('Zone 2')),
                  DropdownMenuItem(value: 2, child: Text('Zone 3')),
                ],
                value: _zone,
                onChanged: (value) {
                  setState(() {
                    _zone = value as int;
                  });
                },
                decoration: InputDecoration(labelText: 'Zone'),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une zone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  // await patenteManagement.getAllContribuables();
                  await patenteManagement.getCommerceAjouteEvents();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Appel de la fonction pour enregistrer le commerce en utilisant Web3dart
                    // enregisterCommerce(
                    //   _name,
                    //   _physicalAddress,
                    //   _latitude,
                    //   _longitude,
                    //   _chiffreAffaires,
                    //   _classification,
                    //   _zone,
                    // );
                  }
                },
                child: Text('Enregistrer'),
              ),
              // FutureBuilder(
              //   future: getContribuable(),
              //   builder: (context, AsyncSnapshot<dynamic> responses) {
              //     String myresult = responses.data;
              //     print(myresult);
              //     return Text(myresult);
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> enregisterCommerce(
  //   String name,
  //   String physicalAddress,
  //   String latitude,
  //   String longitude,
  //   int chiffreAffaires,
  //   int classification,
  //   int zone,
  // ) async {
  //   // Connexion au nœud Ethereum en utilisant Web3dart

  //   // Appel de la fonction pour enregistrer le commerce
  //   patenteManagement.registerCommerce(
  //     name,
  //     physicalAddress,
  //     latitude,
  //     longitude,
  //     chiffreAffaires,
  //     classification,
  //     zone,
  //   );
  // }
}

// Utilisez cette fonction pour enregistrer le commerce en utilisant Web3dart
