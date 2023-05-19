import 'package:flutter/material.dart';

const Color kWhiteColor = Colors.white;
const Color kBlackColor = Colors.black;
const Color kAppBarIconColor = Colors.grey;
const Color kTextBlackColor = kBlackColor;
Color kHomeSearchIconColor = Colors.grey.shade600;
const Color bottomNavBarSelectedColor = kBlackColor;
const Color bottomNavBarUnselectedColor = Colors.grey;
const Color offerPercentageColor = Colors.green;



// Future<void> checkIfDarkModeIsOn() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? darkMode = prefs.getBool('darkTheme');

//   if (darkMode!) {
//     kWhiteColor = Colors.black;
//     kBlackColor = Colors.white;
//     kAppBarIconColor = Colors.grey.shade400;
//     kTextBlackColor = kWhiteColor;
//     kHomeSearchIconColor = Colors.grey.shade300;
//     bottomNavBarSelectedColor = kWhiteColor;
//     bottomNavBarUnselectedColor = Colors.grey.shade400;
//     offerPercentageColor = Colors.green;
//   } else {
//     kWhiteColor = Colors.white;
//     kBlackColor = Colors.black;
//     kAppBarIconColor = Colors.grey;
//     kTextBlackColor = kBlackColor;
//     kHomeSearchIconColor = Colors.grey.shade600;
//     bottomNavBarSelectedColor = kBlackColor;
//     bottomNavBarUnselectedColor = Colors.grey;
//     offerPercentageColor = Colors.green;
//   }
// }
