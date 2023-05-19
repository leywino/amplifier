class Products {
  final String productName;
  final String brand;
  final String category;
  final int quantity;
  final int price;
  final int actualPrice;
  final String description;
  final String longDescription;
  final List? networkImageList;
  final List? colorStringList;
  final String? id;

  Products.fromJson(Map<String, Object?> json)
      : this(
          productName: json['productName']! as String,
          brand: json['brand']! as String,
          category: json['category']! as String,
          quantity: json['quantity']! as int,
          price: json['price']! as int,
          actualPrice: json['actualPrice']! as int,
          description: json['description']! as String,
          longDescription: json['long description']! as String,
          networkImageList: json['networkImageList']! as List,
          id: json['id']! as String,
          colorStringList: json['colorStringList'] as List?,
        );

  Products(
      {required this.brand,
      required this.category,
      required this.quantity,
      required this.price,
      required this.actualPrice,
      required this.description,
      required this.longDescription,
      required this.productName,
      this.id,
      this.networkImageList,this.colorStringList,});
}
