import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/genereal_icons.dart';
import 'package:amplifier/presentation/home_details_screen/widgets/add_to_cart_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';

class HomeDetailsPage extends StatefulWidget {
  const HomeDetailsPage({super.key, required this.data});

  final dynamic data;

  @override
  State<HomeDetailsPage> createState() => _HomeDetailsPageState();
}

class _HomeDetailsPageState extends State<HomeDetailsPage> {
  final ValueNotifier<int> choiceTypeNotifier = ValueNotifier(0);

  final ValueNotifier<int> choiceColorNotifier = ValueNotifier(0);

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  final _dummyChipText = ["3.5mm Without Mic", "Type-C with Mic"];

  int? initialPage;

  @override
  Widget build(BuildContext context) {
    int percentage =
        (widget.data['price'] / widget.data['actualPrice'] * 100.0).round();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  widget.data['networkImageList'].length == 1
                      ? SizedBox(
                          width: size.width,
                          child:
                              Image.network(widget.data['networkImageList'][0]),
                        )
                      : FlutterCarousel(
                          items: List.generate(
                            widget.data['networkImageList'].length,
                            (index) => SizedBox(
                              width: size.width,
                              child: Image.network(
                                widget.data['networkImageList'][index],
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            initialPage: initialPage ?? 0,
                            indicatorMargin: 5,
                            viewportFraction: 1,
                            slideIndicator: const CircularSlideIndicator(
                              indicatorRadius: 4,
                              itemSpacing: 15,
                              currentIndicatorColor: Colors.black,
                            ),
                          ),
                        ),
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
                                "${widget.data['brand']} - ${widget.data['productName']}",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ),
                            cHeartIcon
                          ],
                        ),
                        Text(
                          widget.data['description'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${NumberFormat.decimalPattern().format(widget.data['price'])}",
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$percentage%",
                              style: const TextStyle(
                                  fontSize: 18, color: offerPercentageColor),
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
                              widget.data['long description'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Visibility(
                          visible: widget.data['networkImageList'].length != 1,
                          child: Column(
                            children: [
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
                                    builder: (context, selectedIndex, child) =>
                                        Text(
                                      widget.data['colorStringList']
                                          [selectedIndex],
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
                                    widget.data['networkImageList'].length,
                                    (index) => ValueListenableBuilder(
                                          valueListenable: choiceColorNotifier,
                                          builder: (context, selectedIndex,
                                                  child) =>
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
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                              : const BorderSide(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          widget.data[
                                                                  'networkImageList']
                                                              [index],
                                                        ),
                                                      ),
                                                    ),
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  selected:
                                                      selectedIndex == index,
                                                  onSelected: (value) {
                                                    choiceColorNotifier.value =
                                                        index;
                                                    setState(() {
                                                      initialPage = index;
                                                    });
                                                  }),
                                        )),
                              ),
                            ],
                          ),
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
