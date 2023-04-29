import 'package:amplifier/core/colors/main_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainBgColor,
      elevation: 0,
      // automaticallyImplyLeading: true,
      foregroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(CupertinoIcons.back),
      ),
      title: Text(
        "My Cart",
        style: TextStyle(
          color: kTextBlackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
