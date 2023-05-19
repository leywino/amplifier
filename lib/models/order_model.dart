class Orders {
  final Map? addressMap;
  final num? totalPrice;
  final String? paymentMethod;
  final List? cartList;

  Orders.fromJson(Map<String, Object?> json)
      : this(
          addressMap: json['addressMap']! as Map,
          totalPrice: json['totalPrice']! as num,
          paymentMethod: json['paymentMethod']! as String,
          cartList: json['cartList']! as List,
        );

  Orders({
    required this.addressMap,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cartList,
  });
}
