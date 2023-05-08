import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/genereal_icons.dart';
import 'package:amplifier/presentation/home_details_screen/widgets/add_to_cart_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeDetailsPage extends StatelessWidget {
  HomeDetailsPage({super.key, required this.data});

  final ValueNotifier<int> choiceTypeNotifier = ValueNotifier(0);
  final ValueNotifier<int> choiceColorNotifier = ValueNotifier(0);
  final dynamic data;
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  final _dummyChipText = ["3.5mm Without Mic", "Type-C with Mic"];
  final _dummyColorText = ["Red", "Blue", "White", "Black"];
  final _dummyChipImages = [
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-7HZ-Salnotes-ZERO-Black-01.jpg?v=1660714478&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-7HZ-Salnotes-ZERO-Blue-01.jpg?v=1679480887&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-7HZ-Salnotes-ZERO-White-01.jpg?v=1679480887&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-7HZ-salnotes-ZERO-Red-01.jpg?v=1679480887&width=800"
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // FlutterCarousel(
                  //   items: List.generate(
                  //       _dummyDetailsImages.length,
                  //       (index) => SizedBox(
                  //           width: size.width,
                  //           child: Image.network(_dummyDetailsImages[index]))),
                  //   options: CarouselOptions(
                  //     indicatorMargin: 5,
                  //     viewportFraction: 1,
                  //     slideIndicator: const CircularSlideIndicator(
                  //       indicatorRadius: 4,
                  //       itemSpacing: 15,
                  //       currentIndicatorColor: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                      width: size.width,
                      child: Image.network(data['networkImageString'])),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                "${data['brand']} - ${data['productName']}",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ),
                            cHeartIcon
                          ],
                        ),
                        Text(
                          data['description'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${NumberFormat.decimalPattern().format(data['price'])}",
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "%",
                              style: TextStyle(
                                  fontSize: 20, color: offerPercentageColor),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          width: size.width,
                          child: Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              data['long description'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Color: ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: choiceColorNotifier,
                              builder: (context, selectedIndex, child) => Text(
                                _dummyColorText[selectedIndex],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // implement choicechip color idiot
                          children: List.generate(
                              4,
                              (index) => ValueListenableBuilder(
                                    valueListenable: choiceColorNotifier,
                                    builder: (context, selectedIndex, child) =>
                                        ChoiceChip(
                                      // materialTapTargetSize:
                                      //     MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.white,
                                      label: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.fromBorderSide(
                                              selectedIndex != index
                                                  ? const BorderSide(
                                                      width: 1,
                                                      color: Colors.grey,
                                                    )
                                                  : const BorderSide(
                                                      width: 2,
                                                      color: Colors.black,
                                                    )),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _dummyChipImages[index]),
                                          ),
                                        ),
                                        width: 40,
                                        height: 40,
                                      ),
                                      selected: selectedIndex == index,
                                      onSelected: (value) =>
                                          choiceColorNotifier.value = index,
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            const Text("Type: "),
                            ValueListenableBuilder(
                              valueListenable: choiceTypeNotifier,
                              builder: (context, selectedIndex, child) => Text(
                                _dummyChipText[selectedIndex],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(
                            2,
                            (index) => ValueListenableBuilder(
                              valueListenable: choiceTypeNotifier,
                              builder: (context, selectedIndex, child) =>
                                  Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: ChoiceChip(
                                  backgroundColor: Colors.white,
                                  selectedColor: Colors.white,
                                  shape: StadiumBorder(
                                    side: selectedIndex != index
                                        ? const BorderSide(color: Colors.grey)
                                        : const BorderSide(color: Colors.black),
                                  ),
                                  label: Text(
                                    _dummyChipText[index],
                                    style: TextStyle(
                                      color: selectedIndex != index
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: selectedIndex == index,
                                  onSelected: (value) =>
                                      choiceTypeNotifier.value = index,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            right: 10,
            bottom: 10,
            child: AddToCartWidget(),
          )
        ],
      ),
    );
  }
}
