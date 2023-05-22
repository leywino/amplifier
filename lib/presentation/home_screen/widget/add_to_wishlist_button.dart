// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/icons/genereal_icons.dart';
import '../../../models/functions.dart';
import '../../../models/product_model.dart';
import '../../../models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.searchList,
    required this.index,
  });

  final List<Products> searchList;
  final int index;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  bool alreadyAdded = false;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyAdded();
  }

  checkIfAlreadyAdded() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String email = FirebaseAuth.instance.currentUser!.email!;
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(email)
        .collection('wishlist')
        .where('email', isEqualTo: email)
        .where('productId', isEqualTo: widget.searchList[widget.index].id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      if (mounted) {
        setState(() {
          alreadyAdded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
            () async {
          if (!alreadyAdded) {
            addToWishlist(
                Wishlist(
                  id: widget.searchList[widget.index].id,
                ),
                context);
            setState(() {
              alreadyAdded = true;
            });
          } else {
            final FirebaseFirestore firestore = FirebaseFirestore.instance;
            final String email = FirebaseAuth.instance.currentUser!.email!;
            final QuerySnapshot snapshot = await firestore
                .collection('users')
                .doc(email)
                .collection('wishlist')
                .where('email', isEqualTo: email)
                .where('productId',
                    isEqualTo: widget.searchList[widget.index].id)
                .get();
            await deleteFromWishlist(snapshot.docs.first.id);
            setState(() {
              alreadyAdded = false;
            });
          }
        });
      },
      child: SizedBox(
        height: 22,
        width: 22,
        child: alreadyAdded ? cHeartFillIcon : cHeartIcon,
      ),
    );
  }
}
