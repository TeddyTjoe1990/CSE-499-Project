import 'package:app/db/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/models.dart';

class TransactionSearchPage extends StatefulWidget {
  @override
  _TransactionSearchPageState createState() => _TransactionSearchPageState();
}

class _TransactionSearchPageState extends State<TransactionSearchPage> {
  final AuthService _authService = AuthService();

  final dbHelper = DatabaseHelper();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<TransactionModel> filteredTransactions = [];
  bool isLoading = false;

  DateTime? selectedDate;

  Future<void> _search() async {
    setState(() {
      isLoading = true;
    });

    String itemName = itemNameController.text.trim();
    String? date = selectedDate != null
        ? selectedDate!.toIso8601String().substring(0, 10) // yyyy-mm-dd
        : null;

    // Método que filtra por itemName y/o fecha
    List<TransactionModel> results = await dbHelper.searchTransactions(
      itemName: itemName.isNotEmpty ? itemName : null,
      date: date,
    );

    setState(() {
      filteredTransactions = results;
      isLoading = false;
    });
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Transacciones'),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre de ítem',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    itemNameController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Buscar por fecha (YYYY-MM-DD)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _search, child: Text('Buscar')),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: filteredTransactions.isEmpty
                        ? Text('No se encontraron transacciones.')
                        : ListView.builder(
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final tx = filteredTransactions[index];
                              return ExpansionTile(
                                title: Text(
                                  'Total: \$${tx.precioTotal.toStringAsFixed(2)} - Cambio: \$${tx.cambio.toStringAsFixed(2)}',
                                ),
                                children: tx.items.map((item) {
                                  return ListTile(
                                    title: Text(item['nombre']),
                                    subtitle: Text(
                                      'Cantidad: ${item['cantidad']}',
                                    ),
                                    trailing: Text(
                                      '\$${(item['precio'] as double).toStringAsFixed(2)}',
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
