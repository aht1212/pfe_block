import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/agent_model.dart';

class AgentDataSource extends DataGridSource {
  AgentDataSource(this.agents);

  final List<Agent> agents;

  @override
  List<DataGridRow> get rows => agents.map<DataGridRow>((agent) {
        return DataGridRow(cells: [
          DataGridCell<String>(columnName: 'id', value: agent.id.toString()),
          DataGridCell<String>(
              columnName: 'ethAddress', value: agent.ethAddress.toString()),
          DataGridCell<String>(columnName: 'nom', value: agent.nom),
          DataGridCell<String>(columnName: 'prenom', value: agent.prenom),
          DataGridCell<String>(columnName: 'adresse', value: agent.adresse),
          DataGridCell<String>(columnName: 'email', value: agent.email),
          DataGridCell<String>(
              columnName: 'telephone', value: agent.telephone.toString()),
        ]);
      }).toList();

  @override
  bool shouldRecalculateColumnWidths() => true;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return Colors.transparent;
      }

      return Colors.grey.withOpacity(0.3);
    }

    return DataGridRowAdapter(
      color: getRowBackgroundColor(),
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: dataGridCell.columnName == 'id'
              ? Alignment.center
              : Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

  void updateDataGridSource({RowColumnIndex? rowColumnIndex}) {
    notifyListeners();
  }
}
