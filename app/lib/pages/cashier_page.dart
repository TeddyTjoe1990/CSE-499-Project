import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import '../models/item.dart';
import 'transaction_list_page.dart';  // Pastikan file ini ada untuk list transaksi

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final itemController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  final dbHelper = DatabaseHelper();

  List<Item> items = [];
  double change = 0.0;

  void _addItem() {
    final name = itemController.text.trim();
    final qty = int.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0.0;

    if (name.isEmpty || qty <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid item data!')),
      );
      return;
    }

    setState(() {
      items.add(Item(name: name, price: price, quantity: qty));
    });

    itemController.clear();
    qtyController.clear();
    priceController.clear();
  }

  double get total {
    return items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void _calculateChange(double payment) {
    setState(() {
      change = payment - total;
    });
  }

  Future<void> _saveTransaction() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No items to save!')),
      );
      return;
    }

    if (change < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment is less than total! Calculate change first.')),
      );
      return;
    }

    final now = DateTime.now().toIso8601String();

    final transaction = TransactionModel(
      total: total,
      change: change,
      date: now,
    );

    try {
      await dbHelper.insertTransaction(transaction, change, items);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction saved successfully!')),
      );

      setState(() {
        items.clear();
        change = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving transaction: $e')),
      );
    }
  }

  final paymentController = TextEditingController();

  @override
  void dispose() {
    itemController.dispose();
    qtyController.dispose();
    priceController.dispose();
    paymentController.dispose();
    super.dispose();
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Item
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),

            Divider(),

            // List Items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text('${item.name} x${item.quantity}'),
                    subtitle: Text(
                      'Price: \$${item.price.toStringAsFixed(2)} - Subtotal: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            Divider(),

            // Total and Payment
            Text('Total: \$${total.toStringAsFixed(2)}'),
            TextField(
              controller: paymentController,
              decoration: InputDecoration(labelText: 'Payment'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double payment = double.tryParse(paymentController.text) ?? 0.0;
                if (payment <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enter valid payment amount')),
                  );
                  return;
                }
                _calculateChange(payment);
              },
              child: Text('Calculate Change'),
            ),
            SizedBox(height: 10),
            Text('Change: \$${change.toStringAsFixed(2)}'),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: Text('Save Transaction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
