import 'package:app/db/services/auth_service.dart';
import 'package:app/pages/search_transactions.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/models.dart';

class TransactionListPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionSearchPage(),
              ),
            );
          },
          child: Text('Search Transactions'),
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: dbHelper
            .getTransactions(), // debe traer items dentro del modelo
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No transactions yet'));

          final transactions = snapshot.data!;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return ExpansionTile(
                title: Text(
                  'Total: \$${tx.precioTotal.toStringAsFixed(2)} - Cambio: \$${tx.cambio.toStringAsFixed(2)}',
                ),
                children: tx.items.map((item) {
                  return ListTile(
                    title: Text(item['nombre']),
                    subtitle: Text('Cantidad: ${item['cantidad']}'),
                    trailing: Text(
                      '\$${(item['precio'] as double).toStringAsFixed(2)}',
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
