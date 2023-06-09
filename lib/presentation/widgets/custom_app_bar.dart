import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import '../address_screen/address_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      required this.showBackButton,
      this.showTabBar = false,
      this.replaceNavigatorPop = false,
      this.showTrailingIcon = false,
      this.goToProfileScreen = false});

  final String title;
  final bool showBackButton;
  final bool showTrailingIcon;
  final bool showTabBar;
  final bool replaceNavigatorPop;
  final bool goToProfileScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteColor,
      elevation: 0,
      // automaticallyImplyLeading: true,
      foregroundColor: kBlackColor,
      leading: showBackButton
          ? IconButton(
              onPressed: () => !replaceNavigatorPop
                  ? Navigator.pop(context)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const BottomNavBar(),
                      ),
                      (route) => false,
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
      actions: showTrailingIcon ? [const AddressEditButton()] : null,
    );
  }
}

class AddressEditButton extends StatefulWidget {
  const AddressEditButton({
    super.key,
  });

  @override
  State<AddressEditButton> createState() => _AddressEditButtonState();
}

class _AddressEditButtonState extends State<AddressEditButton> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () {
          !isTapped ? radioNotifier.value = 10 : radioNotifier.value = 0;
          setState(() {
            isTapped = !isTapped;
          });
        },
        child: isTapped
            ? SvgPicture.asset('assets/icons/check.svg')
            : SvgPicture.asset('assets/icons/edit.svg'),
      ),
    );
  }
}
