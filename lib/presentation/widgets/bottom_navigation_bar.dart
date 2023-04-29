import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/bottom_nav_icons.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:amplifier/presentation/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../categories_screen/main_categories_screen.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  ValueNotifier<int> _navIndexNotifier = ValueNotifier(0);
  final _pages = [
    HomeScreen(),
    MainCartScreen(),
    CategoriesScreen(),
    HomeScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _navIndexNotifier,
        builder: (context, navbarIndex, _) {
          return Scaffold(
            body: _pages[navbarIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: kMainBgColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: navbarIndex != 0 ? home1 : home2,
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: navbarIndex != 1
                      ? SizedBox(
                          child: shoppingCart1,
                          height: 28,
                          width: 28,
                        )
                      : SizedBox(
                          child: shoppingCart2,
                          height: 28,
                          width: 28,
                        ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: navbarIndex == 2
                      ? SizedBox(
                          child: gridview1,
                          height: 28,
                          width: 28,
                        )
                      : SizedBox(
                          child: gridview2,
                          height: 28,
                          width: 28,
                        ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: navbarIndex != 3 ? profile1 : profile2,
                  label: 'Profile',
                ),
              ],
              currentIndex: _navIndexNotifier.value,
              selectedItemColor: Colors.black,
              showUnselectedLabels: true,
              iconSize: 20,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle:
                  TextStyle(color: kTextBlackColor, fontSize: 12),
              unselectedLabelStyle: TextStyle(
                  color: kTextBlackColor.withOpacity(0.5), fontSize: 12),
              onTap: (value) {
                _navIndexNotifier.value = value;
              },
            ),
          );
        });
  }
}
