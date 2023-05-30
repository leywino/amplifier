class Orders {
  final Map? addressMap;
  final num? totalPrice;
  final int? orderStatusIndex;
  final String? paymentMethod;
  final String? razorPaymentId;
  final List? cartList;
  final List? productList;

  Orders.fromJson(Map<String, Object?> json)
      : this(
          addressMap: json['addressMap']! as Map,
          totalPrice: json['totalPrice']! as num,
          orderStatusIndex: json['orderStatusIndex']! as int,
          paymentMethod: json['paymentMethod']! as String,
          razorPaymentId: json['razorPaymentId']! as String,
          cartList: json['cartList']! as List,
          productList: json['productList']! as List,
        );

  Orders({
    required this.addressMap,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cartList,
    required this.productList,
    required this.orderStatusIndex,
    this.razorPaymentId,
  });
}
