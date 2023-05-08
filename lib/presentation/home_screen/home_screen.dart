import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:amplifier/presentation/home_screen/widget/home_product_tile.dart';
import 'package:amplifier/presentation/wishlist_screen/main_wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../models/functions.dart';

List myProducts = [];

final dummyImages = [
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Moondrop-Chu--04.jpg?v=1678359402&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Audio-technica-m50x-1160-1160-Black_61b891f0-d385-464a-8dfb-a40bc89d0516.jpg?v=1590592479&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sony-NW-ZX707-012.jpg?v=1674635770&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sennheiser-MOMENTUM-True-Wireless-3-07.jpg?v=1656934758&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Moondrop-Chu--04.jpg?v=1678359402&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Audio-technica-m50x-1160-1160-Black_61b891f0-d385-464a-8dfb-a40bc89d0516.jpg?v=1590592479&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sony-NW-ZX707-012.jpg?v=1674635770&width=800",
  "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sennheiser-MOMENTUM-True-Wireless-3-07.jpg?v=1656934758&width=800",
];
final dummyBrands = [
  "MOONDROP",
  "AUDIO-TECHNICA",
  "SONY",
  "SENNHEISER",
  "MOONDROP",
  "AUDIO-TECHNICA",
  "SONY",
  "SENNHEISER",
];
final dummyNames = [
  "CHU",
  "ATH-M50x",
  "NW-ZX707",
  "MOMENTUM True Wireless 3",
  "CHU",
  "ATH-M50x",
  "NW-ZX707",
  "MOMENTUM True Wireless 3",
];
final dummyDescription = [
  "In-Ears With 1 Dynamic Driver",
  "Closed-Back Studio Headphone",
  "Hi-Res Digital Audio Player",
  "Noise Cancelling True Wireless Earbuds",
  "In-Ears With 1 Dynamic Driver",
  "Closed-Back Studio Headphone",
  "Hi-Res Digital Audio Player",
  "Noise Cancelling True Wireless Earbuds",
];
final dummyPrice = [
  "1,890",
  "11,999",
  "69,990",
  "19,890",
  "1,890",
  "11,999",
  "69,990",
  "19,890",
];
final dummyPercentage = [
  "35",
  "54",
  "7",
  "21",
  "35",
  "54",
  "7",
  "21",
];

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
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainCartScreen(),
                            )),
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
                                return SizedBox(
                                    width: size.width,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                              myProducts = snapshot.data;
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
