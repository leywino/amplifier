import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/cart_screen/widgets/quantity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> quantityNotifier = ValueNotifier(1);

class MainCartScreen extends StatelessWidget {
  const MainCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: "My Cart",
                showBackButton: true,
              ),
              Column(
                children: List.generate(
                  1,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      // width: 300,
                      height: size.height * 0.15,
                      // color: Colors.red,
                      child: Row(
                        children: [
                          Image.network(
                            "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sennheiser-MOMENTUM-True-Wireless-3-07.jpg?v=1656934758&width=800",
                            height: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                // spacing: size.width * 0.2,
                                children: [
                                  SizedBox(
                                    // color: Colors.red,
                                    child: Text(
                                      "Brand - Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    width: size.width * 0.5,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.delete,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: size.height * 0.04,
                                  width: size.width * 0.6,
                                  child: Text(
                                      "Description adfasdfsdafasd afafasdfasdf f afdsfasdfasdfadafa")),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  QuantityCartWidget(),
                                  SizedBox(
                                    width: size.width * 0.2,
                                  ),
                                  FittedBox(
                                    child: ValueListenableBuilder(
                                      valueListenable: quantityNotifier,
                                      builder: (context, quantityValue, _) =>
                                          Text(
                                        "₹${19890 * quantityValue}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
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
                    Text(
                      "₹7,500",
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Add your onPressed function here
                    },
                    icon: Icon(
                      CupertinoIcons.checkmark_square,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
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
    );
  }
}
