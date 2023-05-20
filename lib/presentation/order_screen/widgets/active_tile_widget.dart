import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/colors/main_colors.dart';
import '../../../models/functions.dart';
import '../../../models/order_model.dart';

class ActiveTileWidget extends StatefulWidget {
  const ActiveTileWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<ActiveTileWidget> createState() => _ActiveTileWidgetState();
}

class _ActiveTileWidgetState extends State<ActiveTileWidget> {
  List<Orders> orderList = [];
  @override
  void initState() {
    getOrderList();
    super.initState();
  }

  getOrderList() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Orders> orderList = convertToOrderList(documents);

      if (mounted) {
        setState(() {
          this.orderList = orderList;
        });
      }
    } else {
      setState(() {
        orderList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (orderList.isEmpty) {
      return SizedBox(
        height: size.height * 0.8,
        child: const Center(
          child: Text(
            "You have no active orders!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Column(
        children: List.generate(
      orderList.length,
      (superIndex) => Column(
        children:
            List.generate(orderList[superIndex].cartList!.length, (index) {
          List productList = orderList[superIndex].productList!;
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      height: 100,
                      width: 100,
                      imageUrl: productList[index]['networkImageList'].first,
                      placeholder: (context, url) => Shimmer(
                        color: kBlackColor,
                        child: Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          width: widget.size.width,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/icons/no_image.svg'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productList[index]['productName'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: widget.size.width * 0.6,
                          child: Text(
                            productList[index]['description'],
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: widget.size.height * 0.02),
                        Padding(
                          padding:
                              EdgeInsets.only(left: widget.size.width * 0.25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    orderCancelConfirm(
                                      context,
                                      orderList[superIndex].cartList![index]
                                          ['productId'],
                                      orderList[superIndex].cartList!,
                                      index,
                                      superIndex,
                                      productList,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: kBlackColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Track',
                                    style: TextStyle(
                                      color: kWhiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    ));
  }

  orderCancelConfirm(BuildContext context, String productId, List cartList,
      int index, int superIndex, List productList) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Cancel Order',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Are you sure you want to cancel this order?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kWhiteColor)),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kWhiteColor)),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        await cancelOrderItem(context, productId, cartList,
                            index, superIndex, productList);
                        Navigator.pop(context, true);
                        setState(() {
                          getOrderList();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
