// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/icons/genereal_icons.dart';
import '../../../models/functions.dart';
import '../../../models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddToWishlistButton extends StatefulWidget {
  const AddToWishlistButton({
    super.key,
    required this.searchList,
    required this.index,
  });

  final List searchList;
  final int index;

  @override
  State<AddToWishlistButton> createState() => _AddToWishlistButtonState();
}

class _AddToWishlistButtonState extends State<AddToWishlistButton> {
  bool alreadyAdded = false;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyAdded();
  }

  Future<void> checkIfAlreadyAdded() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot snapshot = await firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .where('productName',
            isEqualTo: widget.searchList[widget.index]['productName'])
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        alreadyAdded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (!alreadyAdded) {
          addToWishlist(
              Wishlist(
                brand: widget.searchList[widget.index]['brand'],
                category: widget.searchList[widget.index]['category'],
                quantity: widget.searchList[widget.index]['quantity'],
                price: widget.searchList[widget.index]['price'],
                description: widget.searchList[widget.index]['description'],
                longDescription: widget.searchList[widget.index]
                    ['long description'],
                productName: widget.searchList[widget.index]['productName'],
                networkImageString: widget.searchList[widget.index]
                    ['networkImageString'],
              ),
              context);
          setState(() {
            alreadyAdded = true;
          });
        } else {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          final String userId = FirebaseAuth.instance.currentUser!.uid;
          final QuerySnapshot snapshot = await firestore
              .collection('wishlist')
              .where('userId', isEqualTo: userId)
              .where('productName',
                  isEqualTo: widget.searchList[widget.index]['productName'])
              .get();

          deleteFromWishlist(snapshot.docs.first.id, context);
          setState(() {
            alreadyAdded = false;
          });
        }
      },
      icon: SizedBox(
        height: 22,
        width: 22,
        child: !alreadyAdded ? cHeartIcon : cHeartFillIcon,
      ),
    );
  }
}
