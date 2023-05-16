import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/cart_screen/widgets/checkout_screen.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/cart_screen/widgets/quantity_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

ValueNotifier<int> quantityNotifier = ValueNotifier(1);

class MainCartScreen extends StatefulWidget {
  const MainCartScreen({super.key});

  @override
  State<MainCartScreen> createState() => _MainCartScreenState();
}

class _MainCartScreenState extends State<MainCartScreen> {
  bool cartIsEmpty = false;
  @override
  void initState() {
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
      setState(() {
        totalPrice;
      });
      totalPriceNotifier.value = totalPrice;
    }
  }

  Stream getProduct() async* {
    List<String> productIdList = [];
    final String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart')
        .get();

    for (var doc in querySnapshot.docs) {
      productIdList.add(doc.get('productId'));
    }

    if (querySnapshot.docs.isNotEmpty) {
      final snapshot = FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: productIdList)
          .snapshots();

      await for (QuerySnapshot productSnapshot in snapshot) {
        List<DocumentSnapshot> documents = productSnapshot.docs.toList();
        yield documents;
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                title: "My Cart",
                showBackButton: false,
              ),
              StreamBuilder(
                stream: getProduct(),
                builder: (context, snapshot) {
                  final email = FirebaseAuth.instance.currentUser!.email;
                  if (snapshot.hasError) {
                    return const Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.black),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return cartShimmerEffect(size);
                  }
                  if (!snapshot.hasData) {
                    cartIsEmpty = true;
                    return const Center(
                      child: Text('Cart is empty!'),
                    );
                  }
                  final data = snapshot.data;

                  return Column(
                    children: List.generate(
                      data.length,
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
                                  child: Image.network(
                                    data[index]['networkImageList'][0],
                                    height: 120,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            "${data[index]['brand']} - ${data[index]['productName']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDeleteConfirmationDialog(
                                                context, data[index]['id']);
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/delete.svg',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.06,
                                      width: size.width * 0.6,
                                      child: Text(
                                        data[index]['description'],
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
                                          productData: data,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                        ),
                                        FittedBox(
                                            child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(email)
                                              .collection('cart')
                                              .snapshots(),
                                          builder: (context, snapshot2) {
                                            if (snapshot2.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('hi');
                                            }
                                            if (!snapshot.hasData) {
                                              return const Text(
                                                "₹0",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              );
                                            }
                                            final data2 =
                                                snapshot2.data!.docs.toList();

                                            return Text(
                                              "₹${data2[index]['price']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            );
                                          },
                                        )),
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
          ),
        ),
        bottomSheet: Visibility(
          visible: totalPrice != 0,
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

  showDeleteConfirmationDialog(BuildContext context, String documentId) {
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
                setState(() {});
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
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
