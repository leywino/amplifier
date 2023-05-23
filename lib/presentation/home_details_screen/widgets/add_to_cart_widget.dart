// ignore_for_file: deprecated_member_use
import 'package:amplifier/models/cart_model.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/login_screen/widgets/forgot_password.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/colors/main_colors.dart';
import '../../../models/product_model.dart';

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({
    super.key,
    required this.data,
  });
  final Products data;

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  @override
  void initState() {
    checkIfAlreadyAdded();
    super.initState();
  }

  bool alreadyAdded = false;

  checkIfAlreadyAdded() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String email = FirebaseAuth.instance.currentUser!.email!;
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(email)
        .collection('cart')
        .where('productId', isEqualTo: widget.data.id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        alreadyAdded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: InkWell(
        onTap: () async {
          if (alreadyAdded == false) {
            if (widget.data.quantity > 0) {
              addToCart(
                  Cart(
                    productId: widget.data.id,
                    quantity: 1,
                    price: widget.data.price,
                    totalPrice: widget.data.price,
                  ),
                  context);
              setState(() {
                alreadyAdded = true;
              });
            } else {
              showEmailSentSnackbar(context, "This product is out of stock");
            }
          } else {
            // final FirebaseFirestore firestore = FirebaseFirestore.instance;
            // final String email = FirebaseAuth.instance.currentUser!.email!;
            // final QuerySnapshot snapshot = await firestore
            //     .collection('users')
            //     .doc(email)
            //     .collection('cart')
            //     .where('productId', isEqualTo: widget.data.id)
            //     .get();
            // await deleteFromCart(snapshot.docs.first.id);
            // setState(() {
            //   alreadyAdded = false;
            // });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(
                    pageIndex: 1,
                  ),
                ),
                (route) => false);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              child: Container(
                color: kBlackColor,
                width: size.width * 0.55,
                height: 60,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        !alreadyAdded ? "Add to Cart" : "Go to cart",
                        style:
                            const TextStyle(fontSize: 18, color: kWhiteColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
