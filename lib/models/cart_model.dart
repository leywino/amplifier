class Cart {
  final String? id;
  final String? color;
  final String? productId;
  final int? quantity;
  final int? price;

  Cart({
    this.id,
    required this.price,
    this.color = "Black",
    required this.productId,
    required this.quantity,
  });
}
