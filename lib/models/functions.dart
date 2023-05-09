import 'dart:developer';
import 'package:amplifier/models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Stream getProducts() async* {
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();
  final List<DocumentSnapshot> docs = querySnapshot.docs.toList();
  yield docs;
}

Stream getWishlist() async* {
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('wishlist').get();
  final List<DocumentSnapshot> docs = querySnapshot.docs.toList();
  yield docs;
}

Future<void> addToWishlist(Wishlist wishlistClass, BuildContext context) async {
  final products = FirebaseFirestore.instance.collection('wishlist');
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final reference = products.doc();
  try {
    showSnackbar(context, "Added to wishlist");
    await reference.set({
      'productName': wishlistClass.productName,
      'brand': wishlistClass.brand,
      'category': wishlistClass.category,
      'description': wishlistClass.description,
      'long description': wishlistClass.longDescription,
      'price': wishlistClass.price,
      'quantity': wishlistClass.quantity,
      'networkImageString': wishlistClass.networkImageString,
      'id': reference.id,
      'userId': userId,
    });
    log("Product Added to wishlist");
  } catch (error) {
    showSnackbar(context, "Failed to add product to wishlist: $error");
    log("Failed to add product to wishlist: $error");
  }
}

Future<void> deleteFromWishlist(String id, BuildContext context) {
  CollectionReference products =
      FirebaseFirestore.instance.collection('wishlist');

  return products.doc(id).delete().then((value) {
    log("Product Deleted");
    showSnackbar(context, "Product was deleted");
  }).catchError((error) {
    log("Failed to delete product: $error");
    showSnackbar(context, "Failed to delete product");
  });
}

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 300),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
