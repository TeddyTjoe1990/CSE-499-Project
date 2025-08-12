import 'package:app/db/database_helper.dart';
import 'package:app/pages/search_transactions.dart';
import 'package:app/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart'; // <- CashierHome page

void main() async {

  // Ensure all widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Asegúrate de que la base de datos se abra o se cree antes de que la UI se renderice.
  await DatabaseHelper().database;

  // El resto de tu código
  final users = await DatabaseHelper().getAllUsers();
  print('Número de usuarios en la base de datos: ${users.length}');

  await DatabaseHelper().verificarTablasYColumnas();
  runApp(CashierApp());
}


// Main widget
class CashierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Cashier',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      // Routes for app pages.
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => CashierHome(),
        '/transaction_list': (context) => TransactionListPage(),
        '/search_transactions': (context) => TransactionSearchPage(),
      },
    );
  }
}
