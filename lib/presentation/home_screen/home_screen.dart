import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/core/icons/genereal_icons.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/home_screen/widget/home_title.dart';
import 'package:amplifier/presentation/wishlist_screen/main_wishlist_screen.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
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
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40)),
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
                  const HomeTitle(),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 / 1.8,
                    shrinkWrap: true,
                    children: List.generate(
                        8,
                        (index) => InkWell(
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
                                      Container(
                                        decoration: BoxDecoration(
                                            // color: Colors.red,
                                            image: DecorationImage(
                                          image:
                                              NetworkImage(dummyImages[index]),
                                          fit: BoxFit.cover,
                                        )),
                                        height: 180,
                                        // width: size.width,
                                      ),
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
                                    dummyBrands[index],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    dummyNames[index],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: kTextBlackColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dummyDescription[index],
                                    style: const TextStyle(
                                        fontSize: 14, color: kTextBlackColor),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹${dummyPrice[index]}",
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
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
