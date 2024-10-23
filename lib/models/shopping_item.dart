class ShoppingItem {
  final String id;
  final String name;
  final String quantity;
  bool isCompleted;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
