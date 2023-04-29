import 'package:amplifier/core/colors/main_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title, required this.showBackButton,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainBgColor,
      elevation: 0,
      // automaticallyImplyLeading: true,
      foregroundColor: Colors.black,
      leading: showBackButton ? IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(CupertinoIcons.back),
      ): null,
      title: Text(
        title,
        style: TextStyle(
          color: kTextBlackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
