import 'package:flutter/material.dart';
import 'package:pfe_block/home_page.dart';
import 'package:pfe_block/services/tax_management_service.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isConnected = false;
  String addressConnected = "";

  PatenteManagement _patenteManagement = PatenteManagement();
  @override
  void initState() {
    super.initState();
    _patenteManagement.setup();
  }

  @override
  Widget build(BuildContext context) {
    return MyHomeRealPage(addressConnected: addressConnected);
  }
}
