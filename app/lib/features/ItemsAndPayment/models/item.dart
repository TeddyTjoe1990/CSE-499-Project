class Item {
  String name;
  double price;
  int quantity;

  Item(this.name, this.price, {this.quantity = 1});

  double get totalPrice => price * quantity;
}
