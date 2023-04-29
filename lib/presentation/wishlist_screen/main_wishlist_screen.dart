import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/genereal_icons.dart';
import 'package:amplifier/presentation/home_details_screen/main_home_details.dart';
import 'package:amplifier/presentation/home_screen/home_screen.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MainWishlistScreen extends StatelessWidget {
  const MainWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kMainBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const CustomAppBar(
                title: "My Wishlist",showBackButton: true,
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1 / 1.8,
                shrinkWrap: true,
                children: List.generate(
                    8,
                    (index) => InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeDetailsPage(),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        // color: Colors.red,
                                        image: DecorationImage(
                                      image: NetworkImage(dummyImages[index]),
                                      fit: BoxFit.cover,
                                    )),
                                    height: 180,
                                    // width: size.width,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: cHeartFillIcon,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                dummyBrands[index],
                                style:
                                    const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                dummyNames[index],
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dummyDescription[index],
                                style: const TextStyle(
                                    fontSize: 14, color: kTextBlackColor),
                                // overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${dummyPrice[index]}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: kTextBlackColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    "%",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: offerPercentageColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
