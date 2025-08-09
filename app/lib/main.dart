import 'package:app/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart'; // <- CashierHome page

void main() => runApp(CashierApp());

class CashierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Cashier',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => CashierHome(),
        '/transaction_list': (context) => TransactionListPage()
      },
    );
  }
}
