import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../shared/custom_text.dart';

class ScoreBreakdown extends StatelessWidget {
  final Map<String, List<int>> scoreData;

  const ScoreBreakdown({super.key, required this.scoreData});

  int calculateTotal(int index) {
    int total = 0;
    scoreData.forEach((key, value) {
      total += value[index];
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columnSpacing: 25.0,
            headingRowColor: MaterialStateProperty.all(lightColorScheme.secondary),
            columns: [
              DataColumn(
                label: Text(
                  "Category",
                  style: AppStyles.informationText.copyWith(color: Colors.blueGrey),
                ),
              ),
              DataColumn(
                label: Text(
                  "Team A",
                  style: AppStyles.informationText.copyWith(color: Colors.blueGrey),
                ),
              ),
              DataColumn(
                label: Text(
                  "Team B",
                  style: AppStyles.informationText.copyWith(color: Colors.blueGrey),
                ),
              ),
            ],
            rows: scoreData.entries.map((entry) {
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.grey.shade200;
                    }
                    return null;
                  },
                ),
                cells: [
                  DataCell(
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      entry.value[0].toString(),
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      entry.value[1].toString(),
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            }).toList()
              ..add(DataRow(cells: [
                DataCell(
                  Text(
                    "TOTAL",
                    style: AppStyles.informationText,
                  ),
                ),
                DataCell(
                  Text(
                    "${calculateTotal(0)}",
                    style: AppStyles.informationText,
                  ),
                ),
                DataCell(
                  Text(
                    "${calculateTotal(1)}",
                    style: AppStyles.informationText,
                  ),
                ),
              ])),
          ),
        ),
      ),
    );
  }
}
