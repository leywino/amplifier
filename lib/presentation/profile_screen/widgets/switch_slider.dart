// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Color kWhiteColor = Colors.white;
// Color kBlackColor = Colors.black;
// Color kAppBarIconColor = Colors.grey;
// Color kTextBlackColor = kBlackColor;
// Color kHomeSearchIconColor = Colors.grey.shade600;
// Color bottomNavBarSelectedColor = kBlackColor;
// Color bottomNavBarUnselectedColor = Colors.grey;
// Color offerPercentageColor = Colors.green;

// class SettingsSwitch extends StatelessWidget {
//   const SettingsSwitch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     loadPreferences();
//     return ValueListenableBuilder(
//       valueListenable: darkThemeNotifier,
//       builder: (context, light, child) => Switch(
//         // This bool value toggles the switch.
//         value: light,
//         activeColor: Colors.grey,
//         onChanged: (bool change) async {
//           kWhiteColor = !light ? Colors.black : Colors.white;
//           kBlackColor = !light ? Colors.white : Colors.black;

//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setBool('darkTheme', change);
//           darkThemeNotifier.value = change;
//         },
//       ),
//     );
//   }
// }

// ValueNotifier<bool> darkThemeNotifier = ValueNotifier(false);

// Future<void> loadPreferences() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   darkThemeNotifier.value = prefs.getBool('darkTheme') ?? false;
// }
