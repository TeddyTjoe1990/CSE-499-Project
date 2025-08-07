class TransactionModel {
  final int? id;
  final String itemName;
  final int quantity;
  final double price;
  final String date;

  TransactionModel({
    this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'date': date,
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
    );
  }
}
