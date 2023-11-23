import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pfe_block/model/bar_graph_model.dart';

import '../../../../model/graph_model.dart';
import '../../responsive.dart';
import 'custom_card.dart';

class BarGraphCard extends StatelessWidget {
  BarGraphCard({super.key});

  final List<BarGraphModel> data = [
    BarGraphModel(
      lable: "Revenu Mensuel",
      color: const Color(0xFFFEB95A),
      graph: [
        GraphModel(x: 0, y: 8000), // Exemple : Revenu mensuel de 8000
        GraphModel(x: 1, y: 8500), // Exemple : Revenu mensuel de 8500
        GraphModel(x: 2, y: 9000), // Exemple : Revenu mensuel de 9000
        GraphModel(x: 3, y: 9500), // Exemple : Revenu mensuel de 9500
        GraphModel(x: 4, y: 10000), // Exemple : Revenu mensuel de 10000
        GraphModel(x: 5, y: 10500), // Exemple : Revenu mensuel de 10500
      ],
    ),
    BarGraphModel(
      lable: "Dépenses Quotidiennes",
      color: const Color(0xFFF2C8ED),
      graph: [
        GraphModel(x: 0, y: 120), // Exemple : Dépenses quotidiennes de 120
        GraphModel(x: 1, y: 130), // Exemple : Dépenses quotidiennes de 130
        GraphModel(x: 2, y: 110), // Exemple : Dépenses quotidiennes de 110
        GraphModel(x: 3, y: 140), // Exemple : Dépenses quotidiennes de 140
        GraphModel(x: 4, y: 120), // Exemple : Dépenses quotidiennes de 120
        GraphModel(x: 5, y: 130), // Exemple : Dépenses quotidiennes de 130
      ],
    ),
    BarGraphModel(
      lable: "Solde du Compte",
      color: const Color(0xFFFFC107),
      graph: [
        GraphModel(x: 0, y: 4500), // Exemple : Solde actuel du compte de 4500
        GraphModel(x: 1, y: 4600), // Exemple : Solde actuel du compte de 4600
        GraphModel(x: 2, y: 4700), // Exemple : Solde actuel du compte de 4700
        GraphModel(x: 3, y: 4800), // Exemple : Solde actuel du compte de 4800
        GraphModel(x: 4, y: 4900), // Exemple : Solde actuel du compte de 4900
        GraphModel(x: 5, y: 5000), // Exemple : Solde actuel du compte de 5000
      ],
    ),
  ];

  final lable = ['M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
          crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
          mainAxisSpacing: 12.0,
          childAspectRatio: Responsive.isMobile(context) ? 16 / 9 : 5 / 4),
      itemBuilder: (context, i) {
        return CustomCard(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[i].lable,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: _chartGroups(
                          points: data[i].graph, color: data[i].color),
                      borderData: FlBorderData(border: const Border()),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                lable[value.toInt()],
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                        )),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  List<BarChartGroupData> _chartGroups(
      {required List<GraphModel> points, required Color color}) {
    return points
        .map((point) => BarChartGroupData(x: point.x.toInt(), barRods: [
              BarChartRodData(
                toY: point.y,
                width: 12,
                color: color.withOpacity(point.y.toInt() > 4 ? 1 : 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              )
            ]))
        .toList();
  }
}
