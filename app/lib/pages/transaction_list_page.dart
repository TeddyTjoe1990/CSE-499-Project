import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionListPage extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction List')),
      body: FutureBuilder<List<TransactionModel>>(
        future: dbHelper.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No transactions yet'));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final tx = snapshot.data![index];
              return ListTile(
                title: Text(tx.itemName),
                subtitle: Text('Qty: ${tx.quantity} | Rp ${tx.price.toStringAsFixed(0)}'),
                trailing: Text(tx.date.substring(0, 10)),
              );
            },
          );
        },
      ),
    );
  }
}
