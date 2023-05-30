import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/order_screen/widgets/active_tile_widget.dart';
import 'package:amplifier/presentation/order_screen/widgets/complete_tile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/functions.dart';
import '../../models/order_model.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          // automaticallyImplyLeading: true,
          foregroundColor: kBlackColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back),
          ),
          title: const Text(
            "My Orders",
            style: TextStyle(
              color: kTextBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('email', isEqualTo: email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Active',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // color: kTextBlackColor,
                                fontSize: 18,
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Text(
                              'Active',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // color: kTextBlackColor,
                                fontSize: 18,
                              ),
                            );
                          }
                          List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          List<Orders> orderList =
                              convertToOrderList(documents);

                          List<Orders> activeOrderList = orderList
                              .where((element) =>
                                  element.orderStatusIndex != 3 &&
                                  element.orderStatusIndex != 4)
                              .toList();
                          return Row(
                            children: [
                              const Text(
                                'Active',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: kTextBlackColor,
                                  fontSize: 18,
                                ),
                              ),
                              Visibility(
                                visible: activeOrderList.isNotEmpty,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 10,
                                      child: Text(
                                        orderList.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
              const Tab(
                child: Text(
                  'Complete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: kTextBlackColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: kTextBlackColor,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: kBlackColor,
                width: 3.0,
              ),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: ActiveTileWidget(size: size),
            ),
            SingleChildScrollView(
              child: CompletedTileWidget(size: size),
            ),
          ],
        ),
      ),
    );
  }
}
