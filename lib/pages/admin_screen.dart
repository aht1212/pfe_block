import 'package:pfe_block/pages/agent_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'admin/adminPage.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return AgentScreen();
    } else {
      return AdminPage();
    }
  }
}
