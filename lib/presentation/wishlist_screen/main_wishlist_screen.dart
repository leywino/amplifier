import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/icons/genereal_icons.dart';

class MainWishlistScreen extends StatefulWidget {
  const MainWishlistScreen({super.key});

  @override
  State<MainWishlistScreen> createState() => _MainWishlistScreenState();
}

class _MainWishlistScreenState extends State<MainWishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CustomAppBar(
                  title: "My Wishlist",
                  showBackButton: true,
                  replaceNavigatorPop: true,
                ),
                StreamBuilder(
                  stream: getWishlist(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (snapshot.hasError) {
                      return const Text(
                        'Something went wrong',
                        style: TextStyle(color: Colors.black),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: double.infinity,
                        height: size.height * 0.8,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.data.isEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        height: size.height * 0.8,
                        child: const Center(
                          child: Text(
                            "Wishlist is Empty!",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    }

                    return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1 / 1.8,
                        shrinkWrap: true,
                        children: List.generate(
                            data.length,
                            (index) => InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeDetailsPage(
                                          data: data[index],
                                        ),
                                      )),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                // color: Colors.red,
                                                image: DecorationImage(
                                              image: NetworkImage(data[index]
                                                  ['networkImageString']),
                                              fit: BoxFit.cover,
                                            )),
                                            height: 180,
                                            // width: size.width,
                                          ),
                                          Positioned(
                                              right: 0,
                                              top: 0,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleteFromWishlist(
                                                        data[index]['id'],
                                                        context);
                                                  });
                                                },
                                                icon: SizedBox(
                                                  height: 22,
                                                  width: 22,
                                                  child: cHeartFillIcon,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Text(
                                        data[index]['brand'],
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      Text(
                                        data[index]['productName'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: kTextBlackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data[index]['description'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: kTextBlackColor),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "₹${NumberFormat.decimalPattern().format(data[index]['price'])}",
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
                                )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
