class Cart {
  final String? id;
  final String? color;
  final String? productId;
  final int? quantity;
  final int? price;

    Cart.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          color: json['color']! as String,
          productId: json['productId']! as String,
          quantity: json['quantity']! as int,
          price: json['price']! as int,
        );

  Cart({
    this.id,
    required this.price,
    this.color = "Black",
    required this.productId,
    required this.quantity,
  });
}