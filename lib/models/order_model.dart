class Orders {
  final Map? addressMap;
  final num? totalPrice;
  final String? paymentMethod;
  final List? cartList;

  Orders({
    required this.addressMap,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cartList,
  });
}
