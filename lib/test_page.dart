import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum UserType {
  Contribuable,
  AgentMairie,
  Administration,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des utilisateurs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navigateToHome(context, UserType.Contribuable);
              },
              child: Text('Connexion Contribuable'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToHome(context, UserType.AgentMairie);
              },
              child: Text('Connexion Agent Mairie'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToHome(context, UserType.Administration);
              },
              child: Text('Connexion Administration'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHome(BuildContext context, UserType userType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(userType: userType),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final UserType userType;

  HomePage({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Type d\'utilisateur: ${getUserTypeString()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            if (userType == UserType.Contribuable) ...[
              // Interface spécifique au contribuable
              Text('Interface Contribuable'),
              // ... Ajoutez ici les widgets spécifiques au contribuable
            ] else if (userType == UserType.AgentMairie) ...[
              // Interface spécifique à l'agent de la mairie
              Text('Interface Agent Mairie'),
              // ... Ajoutez ici les widgets spécifiques à l'agent de la mairie
            ] else if (userType == UserType.Administration) ...[
              // Interface spécifique à l'administration
              Text('Interface Administration'),
              // ... Ajoutez ici les widgets spécifiques à l'administration
            ],
          ],
        ),
      ),
    );
  }

  String getUserTypeString() {
    switch (userType) {
      case UserType.Contribuable:
        return 'Contribuable';
      case UserType.AgentMairie:
        return 'Agent Mairie';
      case UserType.Administration:
        return 'Administration';
      default:
        return 'Inconnu';
    }
  }
}
