import 'package:flutter/material.dart';
import 'package:pfe_block/pages/contribuable/marcheContribuablePage.dart';
import 'package:pfe_block/pages/contribuable/newsPage.dart';
import 'package:pfe_block/pages/contribuable/parametreContribuable.dart';
import 'package:pfe_block/pages/contribuable/patentePage.dart';

import 'package:pfe_block/pages/contribuable/profilePage.dart';

class ContribuableScreen extends StatefulWidget {
  const ContribuableScreen({Key? key}) : super(key: key);

  @override
  State<ContribuableScreen> createState() => _ContribuableScreenState();
}

class _ContribuableScreenState extends State<ContribuableScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NewsFeedPage(),
    PatentePage(),
    MarcheContribuablePage(),
    ProfilePage(),
    COntribuableSettingPage(),
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
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Patentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Marchés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil du Contribuable',
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
