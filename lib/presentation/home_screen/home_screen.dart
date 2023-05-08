import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/core/icons/genereal_icons.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/home_screen/widget/home_title.dart';
import 'package:amplifier/presentation/wishlist_screen/main_wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

final Stream<QuerySnapshot> _productsStream =
    FirebaseFirestore.instance.collection('products').snapshots();

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

ValueNotifier<bool> _headerNotifier = ValueNotifier(false);

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
                            const SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: SizedBox(
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                CustomIcon.filter_4iconfluttter,
                                color: kHomeSearchIconColor,
                              ),
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
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      StreamBuilder(
                        stream: _productsStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          return GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1 / 1.8,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeDetailsPage(),
                                    )),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        data['networkImageString'] != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(data[
                                                        'networkImageString']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                height: 180,
                                              )
                                            : const CircularProgressIndicator(),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: cHeartIcon,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data['brand'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      data['productName'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: kTextBlackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data['description'],
                                      style: const TextStyle(
                                          fontSize: 14, color: kTextBlackColor),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹${data['price']}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: kTextBlackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "%",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: offerPercentageColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
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
