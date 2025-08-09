class TransactionModel {
  final int? id;
  final String itemName;
  final int quantity;
  final double price;
  final String date;
  final double total;
  final double change;

  TransactionModel({
    this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.date,
    required this.total,
    required this.change,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'date': date,
      'total': total,
      'change': change,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      itemName: map['itemName'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : map['price'] as double,
      date: map['date'] as String,
      total: map['total'] is int
          ? (map['total'] as int).toDouble()
          : map['total'] as double,
      change: map['change'] is int
          ? (map['change'] as int).toDouble()
          : map['change'] as double,
    );
  }
}
