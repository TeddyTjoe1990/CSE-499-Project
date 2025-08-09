import 'package:app/features/ItemsAndPayment/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

Item apple = Item("Apple", 1.50, quantity: 2);
Item bread = Item("Bread", 2.00, quantity: 1);

List<Item> items = [apple, bread];

double totalPrice() {
  double total = 0.0;
  for (var item in items) {
    total += item
        .totalPrice; // Usa el nuevo método totalPrice que considera cantidad
  }
  return total;
}

final myController = TextEditingController();

class _MainAppState extends State<MainApp> {
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final quantityController = TextEditingController();
  double change = 0.0;

  @override
  void dispose() {
    itemNameController.dispose();
    itemPriceController.dispose();
    quantityController.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Cashier App"),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Center(
              child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text("Cashier App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Item Name"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: "Enter item name",
                      border: OutlineInputBorder(),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Item Price"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: itemPriceController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Enter price (e.g., 2.50)",
                      border: OutlineInputBorder(),
                      prefixText: "\$ ",
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Quantity"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter quantity (default: 1)",
                      border: OutlineInputBorder(),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String itemName = itemNameController.text.trim();
                      String priceText = itemPriceController.text.trim();
                      String quantityText = quantityController.text.trim();

                      if (itemName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter an item name")),
                        );
                        return;
                      }

                      double? price = double.tryParse(priceText);
                      if (price == null || price <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a valid price")),
                        );
                        return;
                      }

                      int quantity = 1; // Default quantity
                      if (quantityText.isNotEmpty) {
                        int? parsedQuantity = int.tryParse(quantityText);
                        if (parsedQuantity == null || parsedQuantity <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Please enter a valid quantity")),
                          );
                          return;
                        }
                        quantity = parsedQuantity;
                      }

                      setState(() {
                        items.add(Item(itemName, price, quantity: quantity));
                        itemNameController.clear();
                        itemPriceController.clear();
                        quantityController.clear();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "$quantity x $itemName added successfully!")),
                      );
                    },
                    child: Text("Add Item"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Items List:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                color: Colors.blue,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("Item",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 1,
                        child: Text("Qty",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 2,
                        child: Text("Price",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 2,
                        child: Text("Total",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center)),
                    SizedBox(width: 48), // Space for delete button
                  ],
                ),
              ),
              Column(
                children: items.asMap().entries.map((entry) {
                  int index = entry.key;
                  Item item = entry.value;
                  return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(item.name,
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("${item.quantity}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text("\$${item.price.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                                "\$${item.totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                                textAlign: TextAlign.center),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${item.name} removed")),
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                            tooltip: "Remove item",
                          ),
                        ],
                      ));
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total:", style: TextStyle(fontSize: 20)),
                  SizedBox(
                    width: 20,
                  ),
                  Text("\$ " + totalPrice().toStringAsFixed(2),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Payment"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: myController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Enter payment amount",
                      border: OutlineInputBorder(),
                      prefixText: "\$ ",
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String payment = myController.text.trim();

                      if (payment.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please enter payment amount")),
                        );
                        return;
                      }

                      double? paymentNumber = double.tryParse(payment);
                      if (paymentNumber == null || paymentNumber < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please enter a valid payment amount")),
                        );
                        return;
                      }

                      double total = totalPrice();

                      if (paymentNumber < total) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Insufficient payment! Need \$${(total - paymentNumber).toStringAsFixed(2)} more")),
                        );
                        return;
                      }

                      setState(() {
                        change = paymentNumber - total;
                      });
                    },
                    child: Text("Calculate Change"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Change:", style: TextStyle(fontSize: 20)),
                  SizedBox(
                    width: 20,
                  ),
                  Text("\$ " + change.toStringAsFixed(2),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No items to submit")),
                        );
                        return;
                      }

                      if (change < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please calculate payment first")),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Transaction Complete"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Total: \$${totalPrice().toStringAsFixed(2)}"),
                                Text("Payment: \$${myController.text}"),
                                Text("Change: \$${change.toStringAsFixed(2)}"),
                                SizedBox(height: 10),
                                Text("Thank you for your purchase!"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Submit"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        items.clear();
                        myController.clear();
                        itemNameController.clear();
                        itemPriceController.clear();
                        quantityController.clear();
                        change = 0.0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Transaction cleared")),
                      );
                    },
                    child: Text("Clear"),
                  ),
                ],
              ),
            ],
          )
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.max,
              // children: <Widget>[
              //   Text("Cashier App", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
              //   SizedBox(height: 20,),
              //   Row(
              //     children: [
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Text("Item Name"),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Expanded(child: TextField()),
              //       SizedBox(
              //         width: 20,
              //       ),
              //     ],
              //   ),
              //   SizedBox(
              //     height: 20,
              //   ),
              //   Row(
              //     children: [
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Text("Item Price"),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Expanded(child: TextField()),
              //       SizedBox(
              //         width: 20,
              //       ),
              //     ],
              //   ),
              //   SizedBox(
              //     height: 20,
              //   ),
              //   ElevatedButton(
              //     onPressed: (){},
              //     child: Text("Add Item"),
              //   ),
              //   SizedBox(
              //     height: 20,
              //   ),
              //   Text("Items List:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              //   SizedBox(
              //     height: 20,
              //   ),

              // ],
              // ),
              )),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}
