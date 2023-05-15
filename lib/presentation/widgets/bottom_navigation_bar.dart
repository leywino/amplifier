import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/bottom_nav_icons.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:amplifier/presentation/home_screen/home_screen.dart';
import 'package:amplifier/presentation/profile_screen/main_profile_screen.dart';
import 'package:flutter/material.dart';
import '../categories_screen/main_categories_screen.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key, this.pageIndex = 0});

  final int pageIndex;
  final _pages = [
    HomeScreen(),
    const MainCartScreen(),
    const CategoriesScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> navIndexNotifier = ValueNotifier(pageIndex);
    return ValueListenableBuilder(
        valueListenable: navIndexNotifier,
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
                          height: 28,
                          width: 28,
                          child: shoppingCart1,
                        )
                      : SizedBox(
                          height: 28,
                          width: 28,
                          child: shoppingCart2,
                        ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: navbarIndex == 2
                      ? SizedBox(
                          height: 28,
                          width: 28,
                          child: gridview1,
                        )
                      : SizedBox(
                          height: 28,
                          width: 28,
                          child: gridview2,
                        ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: navbarIndex != 3 ? profile1 : profile2,
                  label: 'Profile',
                ),
              ],
              currentIndex: navIndexNotifier.value,
              selectedItemColor: Colors.black,
              showUnselectedLabels: true,
              iconSize: 20,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle:
                  const TextStyle(color: kTextBlackColor, fontSize: 12),
              unselectedLabelStyle: TextStyle(
                  color: kTextBlackColor.withOpacity(0.5), fontSize: 12),
              onTap: (value) {
                navIndexNotifier.value = value;
              },
            ),
          );
        });
  }
}
