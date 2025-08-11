import 'package:app/db/database_helper.dart';
import 'package:app/db/services/auth_service.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CashierHome extends StatefulWidget {
  @override
  _CashierHomeState createState() => _CashierHomeState();
}

class _CashierHomeState extends State<CashierHome> {
  final AuthService _authService = AuthService();

  final itemNameController = TextEditingController();
  final unitPriceController = TextEditingController();
  final quantityController = TextEditingController();
  final amountPaidController = TextEditingController();

  final db = DatabaseHelper();

  double totalAmount = 0;
  double changeAmount = 0;

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  List<Map<String, dynamic>> shoppingList = [];

  void addItem() {
    final itemName = itemNameController.text.trim();
    final unitPrice = num.tryParse(unitPriceController.text) ?? 0;
    final quantity = num.tryParse(quantityController.text) ?? 0;

    if (itemName.isNotEmpty && unitPrice > 0 && quantity > 0) {
      setState(() {
        shoppingList.add({
          'name': itemName,
          'price': unitPrice,
          'quantity': quantity,
        });
        itemNameController.clear();
        unitPriceController.clear();
        quantityController.clear();
        calculateTotal();
      });
    }
  }

  void removeItem(int index) {
    setState(() {
      shoppingList.removeAt(index);
      calculateTotal();
    });
  }

  void calculateTotal() {
    totalAmount = 0;
    for (var item in shoppingList) {
      final price = item['price'] as num;
      final qty = item['quantity'] as num;
      totalAmount += price * qty;
    }

    final amountPaid = num.tryParse(amountPaidController.text) ?? 0;
    changeAmount = amountPaid - totalAmount;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            TransactionModel transaction = TransactionModel(
              precioTotal: totalAmount,
              cambio: changeAmount,
              items: shoppingList,
            );
            db.insertTransactionWithItems(transaction);
          },
          child: Text('Save'),
        ),
      ),
      appBar: AppBar(
        title: Text('Cashier'),
        actions: [
          // Este es el botón de "Cerrar Sesión"
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Llama al método de logout de tu servicio.
              _authService.logout(context);
            },
          ),
        ],
      ),

      resizeToAvoidBottomInset: true, // Avoid keyboard overlapping the content
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: buildCashierForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: buildShoppingList()),
                ],
              );
            } else {
              // Corrección para pantallas angostas
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildCashierForm(),
                    SizedBox(height: 16),
                    buildShoppingList(), // Eliminamos la altura fija
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildCashierForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        SizedBox(height: 10),
        ElevatedButton(onPressed: addItem, child: Text('Add Item')),
        Divider(),
        TextField(
          controller: amountPaidController,
          decoration: InputDecoration(labelText: 'Amount Paid'),
          keyboardType: TextInputType.number,
          onChanged: (_) => calculateTotal(),
        ),
        SizedBox(height: 20),
        Text(
          'Total: ${currencyFormatter.format(totalAmount)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Change: ${currencyFormatter.format(changeAmount)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildShoppingList() {
    final listWidget = shoppingList.isEmpty
        ? Center(child: Text('No items yet'))
        : ListView.builder(
            // shrinkWrap: true y NeverScrollableScrollPhysics ya no son necesarios
            // porque el padre (SingleChildScrollView) se encarga del scroll
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: shoppingList.length,
            itemBuilder: (context, index) {
              final item = shoppingList[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(
                  '${currencyFormatter.format(item['price'])} x ${item['quantity']}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeItem(index),
                ),
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shopping List',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        listWidget,
      ],
    );
  }
}
