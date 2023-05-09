import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.showBackButton,
    this.showTabBar = false,
    this.replaceNavigatorPop = false,
  });

  final String title;
  final bool showBackButton;
  final bool showTabBar;
  final bool replaceNavigatorPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainBgColor,
      elevation: 0,
      // automaticallyImplyLeading: true,
      foregroundColor: Colors.black,
      leading: showBackButton
          ? IconButton(
              onPressed: () => !replaceNavigatorPop
                  ? Navigator.pop(context)
                  : Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BottomNavBar(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    ),
              icon: const Icon(CupertinoIcons.back),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: kTextBlackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
