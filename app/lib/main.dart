import 'package:app/db/database_helper.dart';
import 'package:app/models/transaction_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CashierApp());
}

class Item {
  final String name;
  final double price;
  final int quantity;

  Item({required this.name, required this.price, required this.quantity});
}

class CashierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Cashier',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CashierHomePage(),
    );
  }
}

class CashierHomePage extends StatefulWidget {
  @override
  _CashierHomePageState createState() => _CashierHomePageState();
}

class _CashierHomePageState extends State<CashierHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  List<Item> items = [];
  double change = 0.0;

  final dbHelper = DatabaseHelper();

  double totalPrice() {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void calculateChange() {
    double total = totalPrice();
    double payment = double.tryParse(paymentController.text) ?? 0.0;
    setState(() {
      change = payment - total;
    });
  }

  void addItem() {
    if (_formKey.currentState!.validate()) {
      final name = itemNameController.text;
      final price = double.parse(itemPriceController.text);
      final quantity = int.parse(itemQuantityController.text);

      setState(() {
        items.add(Item(name: name, price: price, quantity: quantity));
      });

      itemNameController.clear();
      itemPriceController.clear();
      itemQuantityController.clear();
    }
  }

  Future<void> submitTransaction() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No items to submit")),
      );
      return;
    }

    if (change < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please calculate payment first")),
      );
      return;
    }

    try {
      double total = totalPrice();
      await dbHelper.insertTransaction(total as TransactionModel, change, items);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Transaction Complete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total: \$${total.toStringAsFixed(2)}"),
              Text("Payment: \$${paymentController.text}"),
              Text("Change: \$${change.toStringAsFixed(2)}"),
              SizedBox(height: 10),
              Text("Transaction saved to database."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  items.clear();
                  paymentController.clear();
                  change = 0.0;
                });
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving transaction: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Cashier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter item name' : null,
                  ),
                  TextFormField(
                    controller: itemPriceController,
                    decoration: InputDecoration(labelText: 'Item Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter item price' : null,
                  ),
                  TextFormField(
                    controller: itemQuantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter quantity' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addItem,
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text('${item.name} x${item.quantity}'),
                    subtitle:
                        Text('Price: \$${item.price} - Subtotal: \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Divider(),
            Text('Total: \$${totalPrice().toStringAsFixed(2)}'),
            TextFormField(
              controller: paymentController,
              decoration: InputDecoration(labelText: 'Payment'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calculateChange,
              child: Text('Calculate Change'),
            ),
            Text('Change: \$${change.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitTransaction,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
