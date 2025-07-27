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
      id: map['id'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      price: map['price'],
      date: map['date'],
    );
  }
}
