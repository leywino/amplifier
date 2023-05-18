import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/strings.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    getAddress();
    super.initState();
  }

  List addressList = [];

  getAddress() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('address');

    QuerySnapshot snapshot = await reference.get();

    List<DocumentSnapshot> documents = snapshot.docs;
    List<dynamic> addressList = documents.map((doc) => doc.data()).toList();
    if (mounted) {
      setState(() {
        this.addressList = addressList;
      });
    }
  }

  int selectedPaymentIndex = 0;
  int selectedAddressIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kMainBgColor,
          body: SingleChildScrollView(
            child: Column(children: [
              const CustomAppBar(title: "Checkout", showBackButton: true),
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          "Choose Your Address",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  addressList.isNotEmpty
                      ? Column(
                          children: List.generate(
                            addressList.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(
                                      12.0), // set the border radius to 12.0
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[400],
                                      child: SvgPicture.asset(
                                          "assets/icons/location.svg"),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addressList[index]['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        FittedBox(
                                          child: Text(
                                            "${addressList[index]['city']} , ${addressList[index]['state']}, ${addressList[index]['pin code']}",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Radio(
                                      value: selectedAddressIndex == index,
                                      groupValue: true,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAddressIndex = index;
                                        });
                                      },
                                      activeColor: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : addressShimmerEffect(size),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      "Choose Payment Method",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                            12.0), // set the border radius to 12.0
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[400],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(paymentIcons[index]),
                            ),
                          ),
                          title: Text(
                            paymentTitles[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Radio(
                            value: selectedPaymentIndex == index,
                            groupValue: true,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentIndex = index;
                              });
                            },
                            activeColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal: size.width * 0.12, vertical: 20)),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

addressShimmerEffect(Size size) {
  return Column(
    children: List.generate(
      2,
      (index) => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer(
                  color: Colors.black,
                  child: SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.09,
                  )),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    ),
  );
}
