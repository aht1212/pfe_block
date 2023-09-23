import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:pfe_block/services/tax_management_service.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/agent_model.dart';
import 'agentDatasource.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  PatenteManagement _patenteManagement = PatenteManagement();
  bool _isLoading = true;
  late final List<Agent> agents;
  Future<List<Agent>>? getAgent;
  int selectedId = -1;

  Future<List<Agent>> getAgents() async {
    agents = await _patenteManagement.getAgentAjouteEvents();

    // setState(() {
    //   _isLoading = false;
    // });
    return agents;
  }

  final DataGridController _datagridController = DataGridController();

  Agent? _agentSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getAgents().then((value) {});
    getAgent = getAgents();
  }

  @override
  Widget build(BuildContext context) {
    // var cells = _datagridController.selectedRows.first.getCells();
    // for (var element in cells) {

    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Section des agents
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Agents",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  FutureBuilder(
                      future: getAgent,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return agentDatagrid(context);
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  // _isLoading
                  //     ? CircularProgressIndicator()
                  //     : agents.isEmpty
                  //         ? Text("Aucun agent enregistré.")
                  //         : agentDatagrid(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SfDataGrid agentDatagrid(BuildContext context) {
    // return SfDataGridTheme(
    //   data: SfDataGridThemeData(selectionColor: Theme.of(context).primaryColor),
    return SfDataGrid(
      // onCellTap: (DataGridCellTapDetails details) {
      //   var _selectedIndex = details.rowColumnIndex.rowIndex - 1;
      //   // setState(() {
      //   selectedId = agents[_selectedIndex].id!;
      //   // _isButtonDisabled = false;
      //   // });
      // },
      headerGridLinesVisibility: GridLinesVisibility.both,
      gridLinesVisibility: GridLinesVisibility.vertical,
      columnWidthMode: ColumnWidthMode.fill,
      allowColumnsResizing: true,

      columnResizeMode: ColumnResizeMode.onResize,
      // controller: _datagridController,
      source: AgentDataSource(agents),
      columns: <GridColumn>[
        GridColumn(
            columnName: 'id',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('ID'),
            )),
        GridColumn(
            columnName: 'ethAddress',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Adresse Eth'),
            )),
        GridColumn(
            columnName: 'nom',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Nom'),
            )),
        GridColumn(
            columnName: 'prenom',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Prénom'),
            )),
        GridColumn(
            columnName: 'adresse',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Adresse'),
            )),
        GridColumn(
            columnName: 'email',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Email'),
            )),
        GridColumn(
            columnName: 'telephone',
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text('Téléphone'),
            )),
      ],
      // Personnalisation de l'apparence des lignes
      rowHeight: 60,

      selectionMode: SelectionMode.multiple,
      // onSelectionChanged: (addedRows, removedRows) {
      //   // setState(() {
      //   _agentSelected = agents[_datagridController.selectedIndex];
      //   // });
      // },
    );
  }
}
