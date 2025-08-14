import 'package:app/db/services/auth_service.dart';
import 'package:app/pages/search_transactions.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/models.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class TransactionListPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  final dbHelper = DatabaseHelper();

  Future<void> _exportToPDF(
    BuildContext context,
    List<TransactionModel> transactions,
  ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text(
            'Transaction Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          ...transactions.map(
            (tx) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Date: ${tx.fechaTransaccion}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('Total: ${tx.precioTotal.toStringAsFixed(2)}'),
                pw.Text('Change: ${tx.cambio.toStringAsFixed(2)}'),
                pw.Text('Items:'),
                pw.Bullet(
                  text: tx.items
                      .map(
                        (item) =>
                            '${item['nombre']} x${item['cantidad']} (	${(item['precio'] as double).toStringAsFixed(2)})',
                      )
                      .join(', '),
                ),
                pw.Divider(),
              ],
            ),
          ),
        ],
      ),
    );
    try {
      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/transactions_report.pdf');
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF exported: ${file.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export PDF: $e')));
    }
  }

  void _exportToExcel(
    BuildContext context,
    List<TransactionModel> transactions,
  ) {
    // TODO: Implement Excel export logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export to Excel not implemented yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.logout(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionSearchPage(),
                  ),
                );
              },
              child: Text('Search Transactions'),
            ),
            ElevatedButton(
              onPressed: () async {
                final transactions = await dbHelper.getTransactions();
                await _exportToPDF(context, transactions);
              },
              child: Text('Export PDF'),
            ),
            ElevatedButton(
              onPressed: () async {
                final transactions = await dbHelper.getTransactions();
                _exportToExcel(context, transactions);
              },
              child: Text('Export Excel'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: dbHelper.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No transactions yet'));

          final transactions = snapshot.data!;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return ExpansionTile(
                title: Text(
                  'Total: \$${tx.precioTotal.toStringAsFixed(2)} - Cambio: \$${tx.cambio.toStringAsFixed(2)}',
                ),
                children: tx.items.map((item) {
                  return ListTile(
                    title: Text(item['nombre']),
                    subtitle: Text('Cantidad: ${item['cantidad']}'),
                    trailing: Text(
                      '\$${(item['precio'] as double).toStringAsFixed(2)}',
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
