import 'package:financial_family_tracker/features/dashboard/states/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/history_transaction_response.dart';

class ScrollableDataTable extends StatelessWidget {
  final List<HistoryTransaction> history;
  final void Function(HistoryTransaction transaction) onEdit;
  final void Function(int transactionId) onDelete;

  const ScrollableDataTable({
    Key? key,
    required this.history,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20, // Adjust spacing between columns
            horizontalMargin: 12, // Adjust margin
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Keterangan')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Jumlah')),
              DataColumn(label: Text('Tanggal')),
              DataColumn(label: Text('Aksi')), // Tambahkan kolom Aksi
            ],
            rows: history.map((expense) {
              final index = history.indexOf(expense) + 1;
              return DataRow(cells: [
                DataCell(Text('$index')),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(expense.description),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(expense.category),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text('Rp. ${expense.amount.toString()}'),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      expense.transactionAt.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          onEdit(expense); // Panggil fungsi edit
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          onDelete(expense.id); // Panggil fungsi delete
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}