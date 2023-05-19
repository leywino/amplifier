import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:checkmark/checkmark.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/colors/main_colors.dart';
import '../../../models/functions.dart';
import '../../../models/order_model.dart';

class OrderLoadingScreen extends StatefulWidget {
  const OrderLoadingScreen({
    super.key,
    required this.addressList,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cartList,
    required this.productList, required this.cartProductIdList,
  });

  final Map addressList;
  final num totalPrice;
  final String paymentMethod;
  final List cartList;
  final List productList;
  final List cartProductIdList;

  @override
  State<OrderLoadingScreen> createState() => _OrderLoadingScreenState();
}

class _OrderLoadingScreenState extends State<OrderLoadingScreen> {
  final email = FirebaseAuth.instance.currentUser!.email;
  bool checked = false;
  @override

  
  void initState() {
    deleteAllCart(widget.cartProductIdList, widget.cartList,);
    addNewOrder(
        Orders(
          addressMap: widget.addressList,
          totalPrice: widget.totalPrice,
          paymentMethod: widget.paymentMethod,
          cartList: widget.cartList,
          productList: widget.productList,
        ),
        context);
    delayChecked();
    super.initState();
  }

  delayChecked() async {
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        setState(() {
          checked = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    navigateToHome(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CheckMark(
                active: checked,
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 700),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              child: DefaultTextStyle(
                style: GoogleFonts.comfortaa(
                  fontSize: 30.0,
                  color: kBlackColor,
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText('Order was Placed'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

navigateToHome(BuildContext context) {
  Future.delayed(
    const Duration(milliseconds: 1500),
    () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        )),
  );
}
