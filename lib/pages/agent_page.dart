import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/pages/agent/contribuableListPage.dart';
import 'package:pfe_block/pages/agent/dashboard.dart';
import 'package:pfe_block/pages/agent/parametre.dart';
import 'package:pfe_block/pages/agent/profilPage.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  @override
  Widget build(BuildContext context) {
    return  AgentRecouvrementHomePage();
  }
}

class AgentRecouvrementHomePage extends StatefulWidget {
  @override
  _AgentRecouvrementHomePageState createState() =>
      _AgentRecouvrementHomePageState();
}

class _AgentRecouvrementHomePageState extends State<AgentRecouvrementHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    ContribuablesListPage(),
    AgentProfilePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste des Contribuables',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil de l\'Agent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}



