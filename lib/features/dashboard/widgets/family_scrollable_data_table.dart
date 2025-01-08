import 'package:flutter/material.dart';

import '../data/models/family_history_trasnsaction_response.dart';

class FamilyScrollableDataTable extends StatelessWidget {
  final List<FamilyHistoryTransaction> history;

  const FamilyScrollableDataTable({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20, // Adjust spacing between columns
          horizontalMargin: 12, // Adjust margin
          columns: const [
            DataColumn(label: Text('No')),
            DataColumn(label: Text('Keterangan')),
            DataColumn(label: Text('Username')),
            DataColumn(label: Text('Kategori')),
            DataColumn(label: Text('Jumlah')),
            DataColumn(label: Text('Tanggal')),
          ],
          rows: history.map((expense) {
            final index = history.indexOf(expense) + 1;
            return DataRow(cells: [
              DataCell(
                SizedBox(
                  width: 40, // Fixed width for number column
                  child: Text('$index'),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120, // Adjust width based on content
                  child: Text(
                    expense.member.user.username,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120, // Adjust width based on content
                  child: Text(
                    expense.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100, // Adjust width based on content
                  child: Text(
                    expense.category,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 120, // Adjust width based on content
                  child: Text(
                    'Rp. ${expense.amount.toString()}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100, // Adjust width based on content
                  child: Text(
                    expense.transactionAt.toLocal().toString().split(' ')[0],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}