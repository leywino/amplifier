import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/presentation/home_screen/widget/home_product_tile.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:amplifier/presentation/wishlist_screen/main_wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../models/functions.dart';



class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier _isAtTop = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.offset <= 60) {
          _isAtTop.value = true;
        } else {
          _isAtTop.value = false;
        }
      });
    });

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => BottomNavBar(
                              pageIndex: 1,
                            ),
                            transitionDuration: const Duration(seconds: 0),
                          ),
                        ),
                        icon: const Icon(
                          CustomIcon.buy_2iconfluttter,
                          color: kAppBarIconColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainWishlistScreen(),
                            )),
                        icon: const Icon(
                          CustomIcon.hearticonfluttter,
                          color: kAppBarIconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StickyHeader(
                header: ValueListenableBuilder(
                  valueListenable: _isAtTop,
                  builder: (context, isAtTop, child) => Padding(
                    padding: isAtTop
                        ? EdgeInsets.symmetric(horizontal: size.width * 0.05)
                        : EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            isAtTop ? BorderRadius.circular(40) : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                CustomIcon.search_2iconfluttter,
                                color: kHomeSearchIconColor,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              height: 35,
                              child: Center(
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                content: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ValueListenableBuilder(
                        valueListenable: searchController,
                        builder: (context, searchController, child) {
                          return StreamBuilder(
                            stream: getProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text(
                                  'Something went wrong',
                                  style: TextStyle(color: Colors.black),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return homeProductShimmerEffect();
                              }
                              List myProducts = snapshot.data;
                              List<dynamic> searchList = myProducts
                                  .where((element) => element['productName']
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchController.text
                                          .toLowerCase()
                                          .replaceAll(RegExp(r"\s+"), "")))
                                  .toList();

                              return HomeProductTile(searchList: searchList);
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
