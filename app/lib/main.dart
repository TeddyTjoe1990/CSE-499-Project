import 'package:app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

Item apple = Item("Apple", 1.50);
Item bread = Item("Bread", 2.00);

List<Item> items = [apple, bread];  

class MainApp extends StatelessWidget {
  const MainApp({super.key});



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
              Text("Cashier App", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text("Item Name"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: TextField()),
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
                  Expanded(child: TextField()),
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
                    onPressed: (){},
                    child: Text("Add Item"),
                  ),
                ],
              ),
              
              SizedBox(
                height: 20,
              ),
              Text("Items List:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Item", style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text("Price", style: TextStyle(fontSize: 20, color: Colors.white))
                  ],
                ),
              ),
              
              Column(
                children: items.map((item) {
                  // return Text(item.name + " - " + item.price.toString());
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(item.name, style: TextStyle(fontSize: 25),),
                        Text("\$ " + item.price.toStringAsFixed(2), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      ],
                    )
                  );
                  
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Total")

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
        )
      ),
    );
  }
}
