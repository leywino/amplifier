class Cart {
  final String? id;
  final String? color;
  final String? productId;
  final int? quantity;
  final int? totalPrice;
  final int? price;

    Cart.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          color: json['color']! as String,
          productId: json['productId']! as String,
          quantity: json['quantity']! as int,
          totalPrice: json['totalPrice']! as int,price: json['price']! as int,
        );

  Cart({
    this.id,
    required this.totalPrice,
    this.color = "Black",
    required this.productId,
    required this.quantity,
    required this.price,
  });
}