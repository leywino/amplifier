import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/models/product_model.dart';
import 'package:amplifier/presentation/home_screen/widget/home_product_tile.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:amplifier/presentation/wishlist_screen/main_wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../models/functions.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier _isAtTop = ValueNotifier(true);
  final ValueNotifier<String> searchStringNotifier = ValueNotifier("");

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
    final email = FirebaseAuth.instance.currentUser!.email;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
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
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(email)
                              .collection('cart')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return IconButton(
                                onPressed: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const BottomNavBar(
                                        pageIndex: 1,
                                      ),
                                    ),
                                    (route) => false),
                                icon: const Icon(
                                  CustomIcon.buy_2iconfluttter,
                                  color: kAppBarIconColor,
                                ),
                              );
                            }
                            if (!snapshot.hasData) {
                              return IconButton(
                                onPressed: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const BottomNavBar(
                                        pageIndex: 1,
                                      ),
                                    ),
                                    (route) => false),
                                icon: const Icon(
                                  CustomIcon.buy_2iconfluttter,
                                  color: kAppBarIconColor,
                                ),
                              );
                            }
                            final cartData = snapshot.data!.docs.toList();
                            return Stack(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: const BottomNavBar(
                                          pageIndex: 1,
                                        ),
                                      ),
                                      (route) => false),
                                  icon: const Icon(
                                    CustomIcon.buy_2iconfluttter,
                                    color: kAppBarIconColor,
                                  ),
                                ),
                                Visibility(
                                  visible: cartData.isNotEmpty,
                                  child: Positioned(
                                    right: 5,
                                    top: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 9,
                                      child: Text(
                                        cartData.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: const MainWishlistScreen()),
                        ),
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
                                  onChanged: (value) {
                                    EasyDebounce.debounce(
                                        'search-debouncer',
                                        const Duration(milliseconds: 400),
                                        () => searchStringNotifier.value =
                                            searchController.text);
                                  },
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
                        valueListenable: searchStringNotifier,
                        builder: (context, searchString, child) {
                          return StreamBuilder(
                            stream: getProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text(
                                  'Something went wrong',
                                  style: TextStyle(color: kBlackColor),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return homeProductShimmerEffect();
                              }
                              List<DocumentSnapshot> documents = snapshot.data!;
                              List<Products> productList =
                                  convertToProductsList(documents);
                              List<Products> searchList = productList
                                  .where((element) => element.productName
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchString
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
