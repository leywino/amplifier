import 'dart:developer';

import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/add_new_address/add_new_address.dart';
import 'package:amplifier/presentation/cart_screen/widgets/order_loading_screen.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/strings.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.cartProductIdList, required this.productList});
  final List cartProductIdList;
  final List productList;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _razorpay = Razorpay();
  @override
  void initState() {
    getAddress();
    getCartList();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    num totalPrice = 0;
    for (int i = 0; i < cartList.length; i++) {
      totalPrice += cartList[i]['totalPrice'];
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderLoadingScreen(
            addressList: addressList[selectedAddressIndex],
            totalPrice: totalPrice,
            paymentMethod: paymentTitles[selectedPaymentIndex],
            cartList: cartList,
            productList: widget.productList,
            cartProductIdList: widget.cartProductIdList,
          ),
        ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showFailure(context, "Failure", "Payment was unsuccessful");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet Selected");
  }

  List addressList = [];
  List cartList = [];

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

  void refreshPageFromAddress() {
    getAddress();
  }

  getCartList() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart');

    QuerySnapshot snapshot = await reference.orderBy('price').get();

    List<DocumentSnapshot> documents = snapshot.docs;
    List<dynamic> cartList = documents.map((doc) => doc.data()).toList();
    if (mounted) {
      setState(() {
        this.cartList = cartList;
      });
    }
  }

  int selectedAddressIndex = 0;
  int selectedPaymentIndex = 0;
  String name = FirebaseAuth.instance.currentUser!.displayName!;
  @override
  Widget build(BuildContext context) {
    if (cartList.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: kBlackColor,
            ),
          ),
        ),
      );
    }

    num totalQuantity = 0;
    num totalPrice = 0;

    for (int i = 0; i < cartList.length; i++) {
      totalPrice += cartList[i]['totalPrice'];
    }

    for (int i = 0; i < cartList.length; i++) {
      totalQuantity += cartList[i]['quantity'];
    }
    bool codAva = totalPrice > 50000;
    if (addressList.isNotEmpty) {
      String words = addressList[selectedAddressIndex]['name'];
      List<String> wordL = words.split(" ");
      if (wordL.length > 1) {
        wordL.removeAt(1);
      }
      name = wordL.join(" ");
    }
    final size = MediaQuery.of(context).size;

    return Container(
      color: kWhiteColor.withOpacity(1),
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: kWhiteColor,
                elevation: 0,
                // automaticallyImplyLeading: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: const BottomNavBar(
                          pageIndex: 1,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                  ),
                ),
                foregroundColor: kBlackColor,

                title: const Text(
                  "Checkout",
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  GestureDetector(
                    child: const Icon(
                      Icons.refresh,
                    ),
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              backgroundColor: kWhiteColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  addressList.isNotEmpty
                      ? Center(
                          child: IntrinsicHeight(
                            child: Container(
                              width: size.width * 0.9,
                              decoration: const BoxDecoration(
                                // color: Colors.amber,
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                  bottom:
                                      BorderSide(color: kBlackColor, width: 1),
                                  right: BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                  left: BorderSide(
                                      color: kBlackColor, width: 1), // Ad
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Deliver to $name, ${addressList[selectedAddressIndex]['pin code']}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "${addressList[selectedAddressIndex]['permanent address']}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${addressList[selectedAddressIndex]['state']}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${addressList[selectedAddressIndex]['city']} - ${addressList[selectedAddressIndex]['pin code']}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            changeAddressPopUp(size);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  'Change',
                                                  style: TextStyle(
                                                    color: kBlackColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewAddresScreen(
                                      fromCheckOut: true,
                                    ),
                                  ));
                            },
                            child: Container(
                              width: size.width * 0.9,
                              height: size.height * 0.1,
                              decoration: const BoxDecoration(
                                // color: Colors.amber,
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                  bottom:
                                      BorderSide(color: kBlackColor, width: 1),
                                  right: BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                  left: BorderSide(
                                      color: kBlackColor, width: 1), // Ad
                                ),
                              ),
                              child: const Center(
                                  child: Text(
                                "Add New Address",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: IntrinsicHeight(
                      child: Container(
                        width: size.width * 0.9,
                        decoration: const BoxDecoration(
                          // color: Colors.amber,
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: kBlackColor,
                            ),
                            bottom: BorderSide(color: kBlackColor, width: 1),
                            right: BorderSide(
                              width: 1,
                              color: kBlackColor,
                            ),
                            left: BorderSide(color: kBlackColor, width: 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Price Details",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "MRP ($totalQuantity item)",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "₹${NumberFormat.decimalPattern().format(totalPrice)}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Shipping",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Free",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "You Pay",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "₹${NumberFormat.decimalPattern().format(totalPrice)}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: const Row(
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
                      (index) => GestureDetector(
                        onTap: () => setState(() {
                          selectedPaymentIndex = index;
                        }),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  12.0), // set the border radius to 12.0
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: index != 0
                                        ? SvgPicture.asset(paymentIcons[index])
                                        : Image.asset(paymentIcons[index]),
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
                                  activeColor: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 60,
                decoration:
                    const BoxDecoration(border: Border(top: BorderSide())),
                width: size.width,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
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
                                  "Grand Total",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "₹${NumberFormat.decimalPattern().format(totalPrice)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          if (codAva && selectedPaymentIndex == 1) {
                            showAlertDialog();
                          } else {
                            if (selectedPaymentIndex == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderLoadingScreen(
                                      addressList:
                                          addressList[selectedAddressIndex],
                                      totalPrice: totalPrice,
                                      paymentMethod:
                                          paymentTitles[selectedPaymentIndex],
                                      cartList: cartList,
                                      productList: widget.productList,
                                      cartProductIdList:
                                          widget.cartProductIdList,
                                    ),
                                  ));
                            } else {
                              final user = FirebaseAuth.instance.currentUser;
                              Map<String, dynamic> options = {
                                'key': 'rzp_test_SyJPXIbUoAO8Lu',
                                'amount': totalPrice * 100,
                                'name': 'Amplifier',
                                'timeout': 300,
                                'description': widget.productList[0]
                                    ['productName'],
                                'prefill': {'contact': '', 'email': user!.email}
                              };
                              _razorpay.open(options);
                            }
                          }
                        },
                        child: Container(
                          color: kBlackColor,
                          width: size.width * 0.6,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Proceed",
                                  style: TextStyle(
                                      fontSize: 18, color: kWhiteColor),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: kWhiteColor,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Alert")),
          content: const Text(
              "Cash On Delivery is not available on orders above ₹50,000!"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedPaymentIndex = 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: kBlackColor),
              ),
            ),
          ],
        );
      },
    );
  }

  changeAddressPopUp(Size size) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: size.width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Choose From Saved Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[400],
                          ),
                          child: const Center(
                            child: Text(
                              'x',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        addressList.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAddressIndex = index;
                            });
                            super.setState(() {
                              selectedAddressIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.0),
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
                                            fontSize: 12,
                                          ),
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
                                      super.setState(() {
                                        selectedAddressIndex = index;
                                      });
                                    },
                                    activeColor: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewAddresScreen(
                              fromCheckOut: true,
                            ),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                    ),
                    child: const Text(
                      "Add New Address",
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

void showFailure(BuildContext context, String title, String message) {
  Widget continueButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    child: const Text(
      "Continue",
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
