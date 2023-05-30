import 'dart:developer';
import 'package:amplifier/models/product_model.dart';
import 'package:amplifier/models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'address_model.dart';
import 'cart_model.dart';
import 'order_model.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 300),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
//products section

Stream getProducts() async* {
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();
  final List<DocumentSnapshot> docs = querySnapshot.docs.toList();
  yield docs;
}

List<Products> convertToProductsList(List<DocumentSnapshot> documents) {
  return documents.map((snapshot) {
    return Products.fromJson(snapshot.data() as Map<String, dynamic>);
  }).toList();
}

//wishlist section

List<Products> convertToWishList(List<DocumentSnapshot> documents) {
  return documents.map((snapshot) {
    return Products.fromJson(snapshot.data() as Map<String, dynamic>);
  }).toList();
}

Future<void> addToWishlist(Wishlist wishlistClass, BuildContext context) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('wishlist').doc();
  try {
    showSnackbar(context, "Added to wishlist");
    await reference.set({
      'productId': wishlistClass.id,
      'id': reference.id,
      'email': email,
    });
    log("Product Added to wishlist");
  } catch (error) {
    showSnackbar(context, "Failed to add product to wishlist: $error");
    log("Failed to add product to wishlist: $error");
  }
}

Future<void> deleteFromWishlist(String id) {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  CollectionReference products = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('wishlist');

  return products.doc(id).delete().then((value) {
    log("Product Deleted");
  }).catchError((error) {
    log("Failed to delete product: $error");
  });
}

//address section

List<Address> convertToAddressList(List<DocumentSnapshot> documents) {
  return documents.map((snapshot) {
    return Address.fromJson(snapshot.data() as Map<String, dynamic>);
  }).toList();
}

Stream getAddress() async* {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('address');
  QuerySnapshot querySnapshot = await collectionReference.get();
  final docs = querySnapshot.docs.toList();
  yield docs;
}

Future<void> addAddress(Address addressClass, BuildContext context) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('address').doc();
  try {
    showSnackbar(context, "Added address");
    await reference.set({
      'name': addressClass.name,
      'id': reference.id,
      'pin code': addressClass.pinCode,
      'permanent address': addressClass.permanentAddress,
      'state': addressClass.state,
      'defaultAddressBool': addressClass.defaultAddressBool,
      'city': addressClass.city,
    });
    log("Added address");
  } catch (error) {
    showSnackbar(context, "Failed to add product to wishlist: $error");
    log("Failed to add product to wishlist: $error");
  }
}

Future<void> updateAddress(
    Address addressClass, BuildContext context, String id) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('address').doc(id);
  try {
    showSnackbar(context, "Updated address");
    await reference.update({
      'name': addressClass.name,
      'id': reference.id,
      'pin code': addressClass.pinCode,
      'permanent address': addressClass.permanentAddress,
      'state': addressClass.state,
      'defaultAddressBool': addressClass.defaultAddressBool,
      'city': addressClass.city,
    });
    log("Updated address");
  } catch (error) {
    showSnackbar(context, "Failed to update address: $error");
    log("Failed to update address: $error");
  }
}

void updateRadioButtonValue(String selectedDocumentId) {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('address')
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc.id == selectedDocumentId) {
        doc.reference.update({'defaultAddressBool': true});
      } else {
        doc.reference.update({'defaultAddressBool': false});
      }
    }
  });
}

Future<void> deleteFromAddress(String id) {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  CollectionReference address = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('address');

  return address.doc(id).delete().then((value) {
    log("Address Deleted");
  }).catchError((error) {
    log("Failed to delete address: $error");
  });
}

//cart section

Future<List<DocumentSnapshot>> getCartList() async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('cart');
  QuerySnapshot querySnapshot = await reference.get();
  return querySnapshot.docs;
}

Future<void> addToCart(Cart cartClass, BuildContext context) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('cart').doc();
  try {
    showSnackbar(context, "Added to cart");
    await reference.set({
      'productId': cartClass.productId,
      'id': reference.id,
      'color': cartClass.color,
      'quantity': cartClass.quantity,
      'price': cartClass.price,
      'totalPrice': cartClass.totalPrice
    });
    log("Added to cart");
  } catch (error) {
    showSnackbar(context, "Failed to add product to cart: $error");
    log("Failed to add product to cart: $error");
  }
}

Future<void> deleteFromCart(String id) {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  CollectionReference products = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('cart');
  return products.doc(id).delete().then((value) {
    log("Removed from cart");
  }).catchError((error) {
    log("Failed to delete product from cart: $error");
  });
}

void deleteAllCart(List cartProductIdList, List cartList) async {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  QuerySnapshot productSnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('id', whereIn: cartProductIdList)
      .orderBy('price')
      .get();

  List<DocumentSnapshot> documents = productSnapshot.docs;
  List<dynamic> productList = documents.map((doc) => doc.data()).toList();

  for (int i = 0; i < cartProductIdList.length; i++) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(cartProductIdList[i])
        .update({
      'quantity': (productList[i]['quantity'] - cartList[i]['quantity']),
    });
  }
  CollectionReference products = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('cart');
  QuerySnapshot snapshot = await products.get();

  WriteBatch batch = FirebaseFirestore.instance.batch();
  for (var document in snapshot.docs) {
    batch.delete(document.reference);
  }
  await batch.commit();
}

Future<void> updateCartQuantity(
    int quantity, num totalPrice, String id, int productQuantity) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('cart').doc(id);
  try {
    if (quantity <= productQuantity) {
      await reference.update({
        'quantity': quantity,
        'totalPrice': totalPrice,
      });
      log("Updated cart quantity");
    } else {
      log("Only $productQuantity products are available");
    }
  } catch (error) {
    log("Failed to update address: $error");
  }
}

//order section

List<Orders> convertToOrderList(List<DocumentSnapshot> documents) {
  return documents.map((snapshot) {
    return Orders.fromJson(snapshot.data() as Map<String, dynamic>);
  }).toList();
}

Future<void> addNewOrder(Orders orderclass, BuildContext context) async {
  final reference = FirebaseFirestore.instance
      .collection('orders')
      .doc(DateTime.now().toString());
  final String email = FirebaseAuth.instance.currentUser!.email!;
  try {
    await reference.set({
      'addressMap': orderclass.addressMap,
      'id': reference.id,
      'cartList': orderclass.cartList,
      'totalPrice': orderclass.totalPrice,
      'paymentMethod': orderclass.paymentMethod,
      'productList': orderclass.productList,
      'email': email,
      'orderStatusIndex': orderclass.orderStatusIndex,
    });
    log("new order placed");
  } catch (error) {
    log("Failed to place new order: $error");
  }
}

Future<void> cancelOrderItem(BuildContext context, List cartList,
    int superIndex, List productList) async {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final collectionRef = FirebaseFirestore.instance.collection('orders');
  final querySnapshot =
      await collectionRef.where('email', isEqualTo: email).get();
  final documentRef = querySnapshot.docs[superIndex].reference;
  List<String> productIdList = [];
  for (var i in cartList) {
    productIdList.add(i['productId']);
  }

  log(productIdList.toString());
  int i = 0;
  for (String id in productIdList) {
    DocumentReference products =
        FirebaseFirestore.instance.collection('products').doc(id);
    DocumentSnapshot snapshot = await products.get();

    final itemQuantity = snapshot.get('quantity');
    final totalItems = cartList[i]['quantity'] + itemQuantity;
    i++;
    CollectionReference productCollectionRef =
        FirebaseFirestore.instance.collection('products');

    productCollectionRef.doc(id).update({'quantity': totalItems});
  }

  documentRef.delete();

  // if (cartList.length != 1) {
  //   int index = cartList.indexWhere(
  //       (element) => element['productId'].toString().contains(productId));
  //   log(index.toString());
  //   productList.removeAt(index);
  //   cartList.removeAt(index);
  //   await documentRef.update({
  //     'cartList': cartList,
  //     'productList': productList,
  //   });
  // } else {

  // }

  //  productCollectionRef
  //     .doc(productId)
  //     .update({'quantity': totalItems}).then((value) {
  //   log("Product quantity updated");
  // }).catchError((error) {
  //   log("Failed to update product quantity: $error");
  // });
}
