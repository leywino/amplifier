// ignore_for_file: deprecated_member_use
import 'package:amplifier/models/cart_model.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/login_screen/widgets/forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Material(
      color: kWhiteColor.withOpacity(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
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
                  showEmailSentSnackbar(
                      context, "This product is out of stock");
                }
              } else {
                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final String email = FirebaseAuth.instance.currentUser!.email!;
                final QuerySnapshot snapshot = await firestore
                    .collection('users')
                    .doc(email)
                    .collection('cart')
                    .where('productId', isEqualTo: widget.data.id)
                    .get();
                await deleteFromCart(snapshot.docs.first.id);
                setState(() {
                  alreadyAdded = false;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(30),
                  color: kBlackColor),
              child: Padding(
                padding: !alreadyAdded
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 8)
                    : const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Visibility(
                      visible: !alreadyAdded,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: SvgPicture.asset(
                          "assets/icons/bag.svg",
                          color: kWhiteColor,
                          height: 24,
                        ),
                      ),
                    ),
                    Text(
                      !alreadyAdded ? "Add to Cart" : "Remove from cart",
                      style: const TextStyle(color: kWhiteColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
