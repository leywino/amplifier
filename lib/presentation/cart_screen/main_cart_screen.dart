import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/cart_screen/widgets/checkout_screen.dart';
import 'package:amplifier/presentation/cart_screen/widgets/quantity_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

ValueNotifier<int> quantityNotifier = ValueNotifier(1);
ValueNotifier<bool> editNotifier = ValueNotifier(false);

class MainCartScreen extends StatefulWidget {
  const MainCartScreen({super.key});

  @override
  State<MainCartScreen> createState() => _MainCartScreenState();
}

class _MainCartScreenState extends State<MainCartScreen> {
  List dataList = [];
  List productPrice = [];
  bool cartIsEmpty = false;
  @override
  void initState() {
    editNotifier = ValueNotifier(false);
    getProduct();
    super.initState();
    getTotalPrice();
  }

  getTotalPrice() async {
    final String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        totalPrice = doc.get('price') + totalPrice;
      }
      if (mounted) {
        setState(() {
          totalPrice;
        });
      }
      totalPriceNotifier.value = totalPrice;
    }
  }

  getProduct() async {
    List<String> productIdList = [];
    List<int> productPrice = [];
    final String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart')
        .get();

    for (var doc in querySnapshot.docs) {
      productIdList.add(doc.get('productId'));
    }
    for (var doc in querySnapshot.docs) {
      productPrice.add(doc.get('price'));
    }
    // log(productIdList.toString());
    if (querySnapshot.docs.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: productIdList)
          .get();

      List<DocumentSnapshot> documents = snapshot.docs;
      List<dynamic> dataList = documents.map((doc) => doc.data()).toList();
      if (mounted) {
        setState(() {
          this.dataList = dataList;
          this.productPrice = productPrice;
        });
      }
    }
  }

  int totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        appBar: AppBar(
          backgroundColor: kMainBgColor,
          elevation: 0,
          // automaticallyImplyLeading: true,
          foregroundColor: Colors.black,

          title: const Text(
            "My Cart",
            style: TextStyle(
              color: kTextBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [
            // GestureDetector(
            //     onTap: () async {
            //       editNotifier.value = !editNotifier.value;
            //     },
            //     child: ValueListenableBuilder(
            //         valueListenable: editNotifier,
            //         builder: (context, value, child) {
            //           return !value
            //               ? SvgPicture.asset('assets/icons/edit.svg')
            //               : SvgPicture.asset('assets/icons/check.svg');
            //         })),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: SingleChildScrollView(
            child: ValueListenableBuilder(
          valueListenable: editNotifier,
          builder: (context, editBool, child) {
            return Column(
              children: [
                StreamBuilder(
                  builder: (context, snapshot) {
                    final email = FirebaseAuth.instance.currentUser!.email;
                    // if (snapshot.hasError) {
                    //   return const Text(
                    //     'Something went wrong',
                    //     style: TextStyle(color: Colors.black),
                    //   );
                    // }
                    // // if (snapshot.connectionState == ConnectionState.waiting) {
                    // //   return cartShimmerEffect(size);
                    // // }
                    // if (!snapshot.hasData) {
                    //   cartIsEmpty = true;
                    //   return const Center(
                    //     child: Text('Cart is empty!'),
                    //   );
                    // }
                    // final data = snapshot.data;

                    if (dataList.isEmpty) {
                      return SizedBox(
                        height: size.height * 0.8,
                        child: const Center(
                          child: Text(
                            "Cart is empty!",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: List.generate(
                        dataList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 7),
                          child: SizedBox(
                            // width: 300,
                            height: size.height * 0.16,
                            // color: Colors.red,
                            child: Container(
                              // color: Colors.red,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: CachedNetworkImage(
                                      imageUrl: dataList[index]
                                          ['networkImageList'][0],
                                      height: 120,
                                      placeholder: (context, url) => Shimmer(
                                        color: Colors.black,
                                        child: const SizedBox(
                                          height: 120,
                                          width: 120,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        // spacing: size.width * 0.2,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: Text(
                                              "${dataList[index]['brand']} - ${dataList[index]['productName']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          true
                                              ? IconButton(
                                                  onPressed: () {
                                                    showDeleteConfirmationDialog(
                                                        context,
                                                        dataList[index]['id'],
                                                        dataList);
                                                  },
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/delete.svg',
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : const SizedBox(
                                                  height: 46,
                                                  width: 46,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.06,
                                        width: size.width * 0.6,
                                        child: Text(
                                          dataList[index]['description'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          QuantityCartWidget(
                                            index: index,
                                            productData: dataList,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.2,
                                          ),
                                          FittedBox(
                                            child: false
                                                ? FutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(email)
                                                        .collection('cart')
                                                        .get(),
                                                    builder:
                                                        (context, snapshot2) {
                                                      if (snapshot2
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Text('hi');
                                                      }
                                                      if (!snapshot.hasData) {
                                                        return const Text(
                                                          "₹0",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        );
                                                      }
                                                      final data2 = snapshot2
                                                          .data!.docs
                                                          .toList();

                                                      if (data2.isEmpty) {
                                                        return const Text(
                                                          "₹0",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        );
                                                      }
                                                      return Text(
                                                        "₹${data2[index]['price']}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Text(
                                                    "₹${productPrice[index]}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        )),
        bottomSheet: Visibility(
          visible: dataList.isNotEmpty,
          child: Container(
            color: kMainBgColor,
            height: size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                          color: kTextBlackColor.withOpacity(0.5),
                          fontSize: 16.0,
                        ),
                      ),
                      TotalPriceWidget(totalPrice: totalPrice),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(),
                            ));
                      },
                      icon: const Icon(
                        CupertinoIcons.checkmark_square,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDeleteConfirmationDialog(
      BuildContext context, String documentId, dynamic data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text(
              'Are you sure you want to delete this product from cart?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                final String email = FirebaseAuth.instance.currentUser!.email!;
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(email)
                    .collection('cart')
                    .where('productId', isEqualTo: documentId)
                    .get();
                await deleteFromCart(querySnapshot.docs.first.id);
                setState(() {
                  dataList.removeWhere((item) => item['id'] == documentId);
                });
                totalPriceNotifier.value =
                    totalPrice - querySnapshot.docs.first.get('price');
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();

                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}

class TotalPriceWidget extends StatelessWidget {
  const TotalPriceWidget({
    super.key,
    required this.totalPrice,
  });

  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: totalPriceNotifier,
      builder: (context, value, child) {
        return Text(
          "₹${NumberFormat.decimalPattern().format(value)}",
          style: const TextStyle(
            color: kTextBlackColor,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}

cartShimmerEffect(Size size) {
  return Column(
    children: List.generate(
      1,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          // width: 300,
          height: size.height * 0.17,
          // color: Colors.red,
          child: Row(
            children: [
              Column(
                children: [
                  Shimmer(
                    color: Colors.black,
                    child: const SizedBox(
                      height: 140,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Shimmer(
                        color: Colors.black,
                        child: SizedBox(
                          // color: Colors.red,
                          width: size.width * 0.5,
                          height: 30,
                          // color: Colors.red,
                        ),
                      ),
                      Shimmer(
                        color: Colors.black,
                        child: const SizedBox(
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  Shimmer(
                    color: Colors.black,
                    child: SizedBox(
                      height: size.height * 0.06,
                      width: size.width * 0.6,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: size.width * 0.2,
                    children: [
                      Shimmer(
                        color: Colors.black,
                        child: SizedBox(
                          width: size.width * 0.2,
                          height: 25,
                        ),
                      ),
                      Shimmer(
                        color: Colors.black,
                        child: SizedBox(
                          width: size.width * 0.2,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
