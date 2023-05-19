import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/cart_screen/widgets/order_loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../core/strings.dart';
import '../../widgets/custom_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.cartProductIdList});
  final List cartProductIdList;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    getAddress();
    getCartList();
    super.initState();
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

  getCartList() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cart');

    QuerySnapshot snapshot = await reference.get();

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
  @override
  Widget build(BuildContext context) {
    if (cartList.isEmpty || addressList.isEmpty) {
      return const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      );
    }
    num totalPrice = 0;
    num totalQuantity = 0;
    for (int i = 0; i < cartList.length; i++) {
      totalPrice += cartList[i]['price'];
    }
    for (int i = 0; i < cartList.length; i++) {
      totalQuantity += cartList[i]['quantity'];
    }
    bool codAva = totalPrice > 50000;
    String words = addressList[selectedAddressIndex]['name'];
    List<String> wordL = words.split(" ");
    wordL.removeAt(1);
    String name = wordL.join(" ");
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white.withOpacity(1),
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: kMainBgColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(title: "Checkout", showBackButton: true),
                  const SizedBox(
                    height: 12,
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
                              color: Colors.black,
                            ),
                            bottom: BorderSide(color: Colors.black, width: 1),
                            right: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            left:
                                BorderSide(color: Colors.black, width: 1), // Ad
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
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                      changeAddressPopUp();
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
                                              color: Colors.black,
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
                              color: Colors.black,
                            ),
                            bottom: BorderSide(color: Colors.black, width: 1),
                            right: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            left: BorderSide(color: Colors.black, width: 1),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderLoadingScreen(
                                      addressMap:
                                          addressList[selectedAddressIndex],
                                      totalPrice: totalPrice,
                                      paymentMethod:
                                          paymentTitles[selectedPaymentIndex],
                                      cartList: cartList),
                                ));
                          }
                        },
                        child: Container(
                          color: Colors.black,
                          width: size.width * 0.6,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Proceed",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: Colors.white,
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
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  changeAddressPopUp() {
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Change Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[400],
                                  child: SvgPicture.asset(
                                      "assets/icons/location.svg"),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  activeColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
