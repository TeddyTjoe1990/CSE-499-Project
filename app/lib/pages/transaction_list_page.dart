import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late Future<List<TransactionModel>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = DatabaseHelper().getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return ListTile(
                title: Text(tx.itemName),
                subtitle: Text('Qty: ${tx.quantity} | Price: \$${tx.price.toStringAsFixed(2)}'),
                trailing: Text(tx.date.split('T').first), // tampilkan tanggal saja
              );
            },
          );
        },
      ),
    );
  }
}
