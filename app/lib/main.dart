import 'package:flutter/material.dart';

void main() => runApp(CashierApp());

class CashierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashier App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CashierHome(),
    );
  }
}

class CashierHome extends StatefulWidget {
  @override
  _CashierHomeState createState() => _CashierHomeState();
}

class _CashierHomeState extends State<CashierHome> {
  final itemNameController = TextEditingController();
  final unitPriceController = TextEditingController();
  final quantityController = TextEditingController();
  final amountPaidController = TextEditingController();

  int totalAmount = 0;
  int changeAmount = 0;

  void calculateTotal() {
    final unitPrice = int.tryParse(unitPriceController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final amountPaid = int.tryParse(amountPaidController.text) ?? 0;

    final total = unitPrice * quantity;
    final change = amountPaid - total;

    setState(() {
      totalAmount = total;
      changeAmount = change;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cashier App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: amountPaidController,
                decoration: InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateTotal,
                child: Text('Calculate Total'),
              ),
              SizedBox(height: 20),
              Text(
                'Total: Rp$totalAmount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Change: Rp$changeAmount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
