// Code for transactions (model)

class TransactionModel {
  int? id;
  double precioTotal;
  double cambio;
  String fechaTransaccion;
  List<Map<String, dynamic>> items;

  TransactionModel({
    this.id,
    required this.precioTotal,
    required this.cambio,
    required this.items,
    required this.fechaTransaccion,
  });
}

// Code for items (model)
class ItemModel {
  int? id;
  String nombre;
  double precio;
  int cantidad;

  ItemModel({
    this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });
}
