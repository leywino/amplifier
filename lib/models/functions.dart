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

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 300),
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
