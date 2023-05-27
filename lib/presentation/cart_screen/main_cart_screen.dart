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
  List productIdList = [];
  List cartList = [];
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
        .orderBy('price')
        .get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    List<dynamic> cartList = documents.map((doc) => doc.data()).toList();
    if (mounted) {
      setState(() {
        this.cartList = cartList;
      });
    }
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        totalPrice = doc.get('totalPrice') + totalPrice;
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
    final String email = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart')
        .orderBy('price')
        .get();

    for (var doc in querySnapshot.docs) {
      productIdList.add(doc.get('productId'));
    }

    // log(productIdList.toString());
    if (querySnapshot.docs.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', whereIn: productIdList)
          .orderBy('price')
          .get();

      List<DocumentSnapshot> documents = snapshot.docs;
      List<dynamic> dataList = documents.map((doc) => doc.data()).toList();
      if (mounted) {
        setState(() {
          this.dataList = dataList;
          this.productIdList = productIdList;
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
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          // automaticallyImplyLeading: true,
          foregroundColor: kBlackColor,

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
                    // if (snapshot.hasError) {
                    //   return const Text(
                    //     'Something went wrong',
                    //     style: TextStyle(color: kBlackColor),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Hero(
                                    tag:
                                        'image_${cartList[index]['productId']}',
                                    child: CachedNetworkImage(
                                      imageUrl: dataList[index]
                                          ['networkImageList'][0],
                                      height: 120,
                                      placeholder: (context, url) => Shimmer(
                                        color: kBlackColor,
                                        child: const SizedBox(
                                          height: 120,
                                          width: 120,
                                        ),
                                      ),
                                    ),
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
                                            "${dataList[index]['brand']} - ${dataList[index]['productName']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDeleteConfirmationDialog(
                                                context,
                                                dataList[index]['id'],
                                                dataList);
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/delete.svg',
                                            // ignore: deprecated_member_use
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.06,
                                      width: size.width * 0.6,
                                      child: Text(
                                        dataList[index]['description'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: kBlackColor,
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
                                          child: Text(
                                            "₹${dataList[index]['price']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
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
              height: 60,
              decoration: const BoxDecoration(
                color: kWhiteColor,
                border: Border(top: BorderSide(), bottom: BorderSide()),
              ),
              width: size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.33,
                    child: Material(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Price",
                                style: TextStyle(fontSize: 16),
                              ),
                              TotalPriceWidget(totalPrice: totalPrice),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              cartProductIdList: productIdList,
                              productList: dataList,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: kBlackColor,
                        width: size.width * 0.67,
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Checkout",
                                style:
                                    TextStyle(fontSize: 18, color: kWhiteColor),
                              ),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                color: kWhiteColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
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
                    totalPrice - querySnapshot.docs.first.get('totalPrice');
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Delete'),
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
            fontSize: 24,
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
                    color: kBlackColor,
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
                        color: kBlackColor,
                        child: SizedBox(
                          // color: Colors.red,
                          width: size.width * 0.5,
                          height: 30,
                          // color: Colors.red,
                        ),
                      ),
                      Shimmer(
                        color: kBlackColor,
                        child: const SizedBox(
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  Shimmer(
                    color: kBlackColor,
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
                        color: kBlackColor,
                        child: SizedBox(
                          width: size.width * 0.2,
                          height: 25,
                        ),
                      ),
                      Shimmer(
                        color: kBlackColor,
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
