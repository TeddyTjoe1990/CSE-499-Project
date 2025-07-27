import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import 'transaction_list_page.dart';

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final itemController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  final dbHelper = DatabaseHelper();

  void _saveTransaction() async {
    final name = itemController.text.trim();
    final qty = int.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final date = DateTime.now().toIso8601String();

    if (name.isEmpty || qty <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid data!')),
      );
      return;
    }

    final transaction = TransactionModel(
      itemName: name,
      quantity: qty,
      price: price,
      date: date,
    );

    await dbHelper.insertTransaction(transaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction saved successfully!')),
    );

    itemController.clear();
    qtyController.clear();
    priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Cashier'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TransactionListPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: Text('Save Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
