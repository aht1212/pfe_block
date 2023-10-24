import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/activite_model.dart';
import '../../services/tax_management_service.dart';

class TaxConfigurationScreen extends StatefulWidget {
  @override
  State<TaxConfigurationScreen> createState() => _TaxConfigurationScreenState();
}

class _TaxConfigurationScreenState extends State<TaxConfigurationScreen> {
  PatenteManagement _patenteManagement = PatenteManagement();
  late Future<List<Activite>> _activitesFuture;
  List<Activite> _activites = [];

  @override
  void initState() {
    super.initState();
    _activitesFuture = getActivites();
  }

  Future<List<Activite>> getActivites() async {
    _activites = await _patenteManagement.getActivites();
    return _activites;
  }

  Future<void> _ajouterActivite(Activite activite) async {
    await _patenteManagement.ajouterActivite(activite,
        EthereumAddress.fromHex("0xC232db3AE5eeaaf67a31cdbA2b448fA323FDABF7"));
    setState(() {
      _activitesFuture = getActivites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Activités Principales'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: TaxConfigurationForm(
              onAjouterActivite: _ajouterActivite,
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 3,
            child: TaxConfigurationList(
              activitesFuture: _activitesFuture,
            ),
          ),
        ],
      ),
    );
  }
}

class TaxConfigurationForm extends StatefulWidget {
  final Function(Activite) onAjouterActivite;

  TaxConfigurationForm({required this.onAjouterActivite});

  @override
  _TaxConfigurationFormState createState() => _TaxConfigurationFormState();
}

class _TaxConfigurationFormState extends State<TaxConfigurationForm> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  int _droitFixeAnnuel = 0;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enregistrer une nouvelle activité principale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom de l\'activité'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le nom de l\'activité principale';
                }
                return null;
              },
              onSaved: (value) {
                _nom = value!;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Droit Fixe Annuel'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le droit fixe annuel';
                }
                return null;
              },
              onSaved: (value) {
                _droitFixeAnnuel = int.parse(value!);
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir une description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final nouvelleActivite = Activite(
                    nom: _nom,
                    droitFixeAnnuel: _droitFixeAnnuel,
                    description: _description,
                  );
                  widget.onAjouterActivite(nouvelleActivite);
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class TaxConfigurationList extends StatefulWidget {
  final Future<List<Activite>> activitesFuture;

  TaxConfigurationList({required this.activitesFuture});

  @override
  _TaxConfigurationListState createState() => _TaxConfigurationListState();
}

class _TaxConfigurationListState extends State<TaxConfigurationList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Activite>>(
        future: widget.activitesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Aucune activité enregistrée.');
          } else {
            final activites = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liste des Activités Principales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: activites!.length,
                    itemBuilder: (context, index) {
                      final activite = activites[index];
                      return Card(
                        child: ListTile(
                          title: Text(activite.nom),
                          subtitle: Text(
                              'Droit Fixe Annuel: ${activite.droitFixeAnnuel}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
