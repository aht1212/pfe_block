import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class COntribuableSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Langue'),
            subtitle: Text('Français'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // TODO: Ajouter la logique pour changer la langue de l'application.
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Ajouter la logique pour activer ou désactiver les notifications.
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supprimer les données'),
            onTap: () {
              // TODO: Ajouter la logique pour supprimer les données de l'application.
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Déconnexion'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // TODO: Ajouter la logique pour supprimer les données de l'application.
            },
          ),
        ],
      ),
    );
  }
}
