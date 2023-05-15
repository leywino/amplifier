import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final ValueNotifier<int> radioNotifier = ValueNotifier(0);

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
                  Column(
                    children: List.generate(
                      3,
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
                                child: SvgPicture.asset(
                                    "assets/icons/location.svg"),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'John Doe',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  FittedBox(
                                    child: Text(
                                      'johndoe@example.com',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ValueListenableBuilder(
                                valueListenable: radioNotifier,
                                builder: (context, radioIndex, child) => Radio(
                                  value: radioIndex == index,
                                  groupValue: true,
                                  onChanged: (value) {
                                    radioNotifier.value = index;
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
                  1,
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
                              child: SvgPicture.asset("assets/icons/upi.svg"),
                            ),
                          ),
                          title: const Text(
                            'UPI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: ValueListenableBuilder(
                            valueListenable: radioNotifier,
                            builder: (context, radioIndex, child) => Radio(
                              value: radioIndex == index,
                              groupValue: true,
                              onChanged: (value) {
                                radioNotifier.value = index;
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
