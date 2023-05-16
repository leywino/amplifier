class Cart {
  final String? id;
  final String? color;
  final String? productId;
  final int? quantity;

  Cart({
    this.id,
    this.color = "Black",
    required this.productId,
    required this.quantity,
  });
}
