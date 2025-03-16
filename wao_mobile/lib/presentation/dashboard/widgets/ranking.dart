import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

class LeagueRanking extends StatelessWidget {
  const LeagueRanking({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: DataTable(
            columnSpacing: 24,
            headingRowHeight: 56,
            dataRowHeight: 60,
            horizontalMargin: 20,
            headingRowColor: MaterialStateProperty.all(lightColorScheme.secondary),
            columns: const [
              DataColumn(
                label: Text(
                  'Rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Team',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'P',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'W',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'D',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'L',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'PTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'GF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'GA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'GD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Team A')),
                  DataCell(Text('10')),
                  DataCell(Text('7')),
                  DataCell(Text('2')),
                  DataCell(Text('1')),
                  DataCell(Text('23')),
                  DataCell(Text('20')),
                  DataCell(Text('10')),
                  DataCell(Text('+10')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Team B')),
                  DataCell(Text('10')),
                  DataCell(Text('6')),
                  DataCell(Text('3')),
                  DataCell(Text('1')),
                  DataCell(Text('21')),
                  DataCell(Text('18')),
                  DataCell(Text('9')),
                  DataCell(Text('+9')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('3')),
                  DataCell(Text('Team C')),
                  DataCell(Text('10')),
                  DataCell(Text('5')),
                  DataCell(Text('4')),
                  DataCell(Text('1')),
                  DataCell(Text('19')),
                  DataCell(Text('15')),
                  DataCell(Text('8')),
                  DataCell(Text('+7')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('4')),
                  DataCell(Text('Team D')),
                  DataCell(Text('10')),
                  DataCell(Text('4')),
                  DataCell(Text('4')),
                  DataCell(Text('2')),
                  DataCell(Text('16')),
                  DataCell(Text('12')),
                  DataCell(Text('10')),
                  DataCell(Text('+2')),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
