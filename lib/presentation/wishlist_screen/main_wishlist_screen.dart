import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/models/product_model.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/icons/genereal_icons.dart';

class MainWishlistScreen extends StatefulWidget {
  const MainWishlistScreen({super.key});

  @override
  State<MainWishlistScreen> createState() => _MainWishlistScreenState();
}

class _MainWishlistScreenState extends State<MainWishlistScreen> {
  List<Products> wishlistList = [];

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  getProduct() async {
    List<String> productIdList = [];
    final String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('wishlist')
        .get();

    for (var doc in querySnapshot.docs) {
      productIdList.add(doc.get('productId'));
    }
    if (querySnapshot.docs.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: productIdList)
          .get();

      List<DocumentSnapshot> documents = snapshot.docs;
      List<Products> wishlistList = convertToWishList(documents);
      setState(() {
        this.wishlistList = wishlistList;
      });
    } else {
      setState(() {
        wishlistList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (wishlistList.isEmpty) {
      return Scaffold(
        backgroundColor: kWhiteColor,
        body: Column(
          children: [
            const CustomAppBar(
              title: "My Wishlist",
              showBackButton: true,
              replaceNavigatorPop: true,
            ),
            SizedBox(
              height: size.height * 0.4,
            ),
            const Center(
              child: Text(
                "Wishlist is Empty",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                    wishlistList.length,
                    (index) => InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeDetailsPage(
                              data: wishlistList[index],
                              productList: wishlistList,
                              index: index,
                            ),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: 'image_${wishlistList[index].id!}',
                                child: Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.red,
                                      image: DecorationImage(
                                    image: NetworkImage(wishlistList[index]
                                        .networkImageList!
                                        .first),
                                    fit: BoxFit.cover,
                                  )),
                                  height: 180,
                                  // width: size.width,
                                ),
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
                                              .where('email', isEqualTo: email)
                                              .where('productId',
                                                  isEqualTo:
                                                      wishlistList[index].id)
                                              .get();
                                      getProduct();
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
                            wishlistList[index].brand,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            wishlistList[index].productName,
                            style: const TextStyle(
                                fontSize: 18,
                                color: kTextBlackColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            wishlistList[index].description,
                            style: const TextStyle(
                                fontSize: 14, color: kTextBlackColor),
                            // overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${NumberFormat.decimalPattern().format(wishlistList[index].price)}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "%",
                                style: TextStyle(
                                    fontSize: 10, color: offerPercentageColor),
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
  }
}
