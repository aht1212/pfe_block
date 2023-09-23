import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout)),
      ),
      body: Center(
        child: Text('Interface Agent Mairie'),
      ),
    );
  }
}
