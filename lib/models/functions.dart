import 'dart:developer';
import 'package:amplifier/models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'address_model.dart';
import 'cart_model.dart';

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

//wishlist section

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
  CollectionReference products = FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('address');

  return products.doc(id).delete().then((value) {
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

Future<void> updateCartQuantity(int quantity, num price,String id) async {
  final users = FirebaseFirestore.instance.collection('users');
  final String email = FirebaseAuth.instance.currentUser!.email!;
  final reference = users.doc(email).collection('cart').doc(id);
  try {
    await reference.update({
      'quantity': quantity,
      'price': price,
    });
    log("Updated cart quantity");
  } catch (error) {
    log("Failed to update address: $error");
  }
}
