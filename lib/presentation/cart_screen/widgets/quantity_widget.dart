import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/cart_screen/main_cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ValueNotifier<num> totalPriceNotifier = ValueNotifier(0);

class QuantityCartWidget extends StatefulWidget {
  const QuantityCartWidget({
    super.key,
    required this.index,
    required this.productData,
  });
  final int index;
  final dynamic productData;

  @override
  State<QuantityCartWidget> createState() => _QuantityCartWidgetState();
}

class _QuantityCartWidgetState extends State<QuantityCartWidget> {
  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser!.email;
    final size = MediaQuery.of(context).size;
    return Container(
      height: 30,
      // width: 1,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
          width: size.width * 0.2,
          child: ValueListenableBuilder(
            valueListenable: editNotifier,
            builder: (context, editBool, child) {
              return true
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(email)
                          .collection('cart')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center();
                        }
                        final data = snapshot.data!.docs.toList();

                        if (data.isEmpty) {
                          return const Text('empty');
                        }
                        int totalPrice = 0;
                        for (int i = 0; i < data.length; i++) {
                          totalPrice = data[i]['price'] + totalPrice;
                        }
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {});
                                int quantity =
                                    await data[widget.index]['quantity'] - 1;
                                num price = 0;

                                if (quantity == 0 || quantity == 1) {
                                  price = await widget.productData[widget.index]
                                      ['price'];
                                } else {
                                  price = await data[widget.index]['price'] -
                                      widget.productData[widget.index]['price'];
                                  quantityNotifier.value--;
                                }
                                quantityNotifier.value--;
                                await updateCartQuantity(
                                    quantity--,
                                    price,
                                    data[widget.index]['id'],
                                    widget.productData[widget.index]
                                        ['quantity']);
                                totalPriceNotifier.value = totalPrice -
                                    widget.productData[widget.index]['price'];
                              },
                              child: const Icon(
                                CupertinoIcons.minus,
                                size: 16,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                    data[widget.index]['quantity'].toString())),
                            GestureDetector(
                              onTap: () async {
                                setState(() {});
                                int quantity =
                                    data[widget.index]['quantity'] + 1;
                                num price = 0;
                                if (quantity == 0 || quantity == 1) {
                                  price = await widget.productData[widget.index]
                                      ['price'];
                                } else {
                                  quantityNotifier.value++;

                                  price = await widget.productData[widget.index]
                                          ['price'] +
                                      data[widget.index]['price'];
                                }
                                await updateCartQuantity(
                                    quantity,
                                    price,
                                    data[widget.index]['id'],
                                    widget.productData[widget.index]
                                        ['quantity']);
                                totalPriceNotifier.value = totalPrice +
                                    widget.productData[widget.index]['price'];
                              },
                              child: const Icon(
                                CupertinoIcons.add,
                                size: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(email)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center();
                        }
                        final data = snapshot.data!.docs.toList();
                        int totalPrice = 0;
                        for (int i = 0; i < data.length; i++) {
                          totalPrice = data[i]['price'] + totalPrice;
                        }
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                int quantity =
                                    await data[widget.index]['quantity'] - 1;
                                num price = 0;

                                if (quantity == 0 || quantity == 1) {
                                  price = await widget.productData[widget.index]
                                      ['price'];
                                } else {
                                  price = await data[widget.index]['price'] -
                                      widget.productData[widget.index]['price'];
                                  quantityNotifier.value--;
                                }
                                quantityNotifier.value--;
                                await updateCartQuantity(
                                    quantity--,
                                    price,
                                    data[widget.index]['id'],
                                    widget.productData[widget.index]
                                        ['quantity']);
                                totalPriceNotifier.value = totalPrice -
                                    widget.productData[widget.index]['price'];
                              },
                              child: const Icon(
                                CupertinoIcons.minus,
                                size: 16,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                    data[widget.index]['quantity'].toString())),
                            GestureDetector(
                              onTap: () async {
                                int quantity =
                                    data[widget.index]['quantity'] + 1;
                                num price = 0;
                                if (quantity == 0 || quantity == 1) {
                                  price = await widget.productData[widget.index]
                                      ['price'];
                                } else {
                                  quantityNotifier.value++;
                                  price = await widget.productData[widget.index]
                                          ['price'] +
                                      data[widget.index]['price'];
                                }
                                await updateCartQuantity(
                                    quantity,
                                    price,
                                    data[widget.index]['id'],
                                    widget.productData[widget.index]
                                        ['quantity']);
                                totalPriceNotifier.value = totalPrice +
                                    widget.productData[widget.index]['price'];
                              },
                              child: const Icon(
                                CupertinoIcons.add,
                                size: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    );
            },
          )),
    );
  }
}
