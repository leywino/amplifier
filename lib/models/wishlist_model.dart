class Wishlist {
  final String productName;
  final String brand;
  final String category;
  final int quantity;
  final int price;
  final String description;
  final String longDescription;
  final String? networkImageString;
  final String? id;
  final String? email;

  Wishlist( 
      {required this.brand,
      required this.category,
      required this.quantity,
      required this.price,
      required this.description,
      required this.longDescription,
      required this.productName,
      this.id,
      required this.networkImageString,this.email,});
}
