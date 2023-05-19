import 'dart:developer';
import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/icons/genereal_icons.dart';

class CategorySpecificGrid extends StatefulWidget {
  const CategorySpecificGrid(
      {super.key,
      required this.categoryTitle,
      required this.categoryFirebaseName});

  @override
  State<CategorySpecificGrid> createState() => _CategorySpecificGridState();
  final String categoryTitle;
  final String categoryFirebaseName;
}

class _CategorySpecificGridState extends State<CategorySpecificGrid> {
  List dataList = [];

  @override
  void initState() {
    super.initState();
  }

  Stream getCategoryProducts() async* {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryFirebaseName)
        .get();

    final List<DocumentSnapshot> docs = querySnapshot.docs.toList();
    log(docs.toString());
    yield docs;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getCategoryProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return categoryShimmerEffect();
        }
        final data = snapshot.data;
        return SafeArea(
          child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: AppBar(
              backgroundColor: kWhiteColor,
              elevation: 0,
              // automaticallyImplyLeading: true,
              foregroundColor: kBlackColor,

              title: Text(
                widget.categoryTitle,
                style: const TextStyle(
                  color: kTextBlackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GridView.count(
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
                                  productList: data,
                                  index: index,
                                ),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  CachedNetworkImage(
                                    height: 180,
                                    imageUrl: data[index]['networkImageList']
                                        [0],
                                    placeholder: (context, url) => Shimmer(
                                      color: kBlackColor,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/icons/no_image.svg'),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                        onPressed: () async {
                                          final String email = FirebaseAuth
                                              .instance.currentUser!.email!;
                                          final QuerySnapshot snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('wishlist')
                                                  .where('email',
                                                      isEqualTo: email)
                                                  .where('productId',
                                                      isEqualTo: data[index]
                                                          ['id'])
                                                  .get();

                                          deleteFromWishlist(
                                              snapshot.docs.first.id);
                                          setState(() {});
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
                                    fontSize: 14, color: kTextBlackColor),
                                // overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

categoryShimmerEffect() {
  return SafeArea(
    child: Scaffold(
      backgroundColor: kWhiteColor,
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
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1 / 1.8,
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer(
                        color: kBlackColor,
                        child: Container(
                          height: 180,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer(
                        color: kBlackColor,
                        child: Container(
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer(
                        color: kBlackColor,
                        child: Container(
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer(
                        color: kBlackColor,
                        child: Container(
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer(
                        color: kBlackColor,
                        child: const SizedBox(
                          height: 30,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
