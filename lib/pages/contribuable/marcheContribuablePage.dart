import 'package:flutter/material.dart';

class MarcheContribuablePage extends StatefulWidget {
  const MarcheContribuablePage({super.key});

  @override
  State<MarcheContribuablePage> createState() => _MarcheContribuablePageState();
}

class _MarcheContribuablePageState extends State<MarcheContribuablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child : Text("Marchés page")),
    );
  }
}
