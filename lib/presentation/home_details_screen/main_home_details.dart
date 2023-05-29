import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/product_model.dart';
import 'package:amplifier/presentation/cart_screen/widgets/checkout_screen.dart';
import 'package:amplifier/presentation/home_details_screen/widgets/add_to_cart_widget.dart';
import 'package:amplifier/presentation/home_details_screen/widgets/full_image_widget.dart';
import 'package:amplifier/presentation/home_screen/widget/add_to_wishlist_button.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../models/cart_model.dart';
import '../../models/functions.dart';

class HomeDetailsPage extends StatefulWidget {
  const HomeDetailsPage(
      {super.key,
      required this.data,
      required this.productList,
      required this.index});

  final Products data;
  final List<Products> productList;
  final int index;

  @override
  State<HomeDetailsPage> createState() => _HomeDetailsPageState();
}

class _HomeDetailsPageState extends State<HomeDetailsPage> {
  final ValueNotifier<int> choiceTypeNotifier = ValueNotifier(0);

  final ValueNotifier<int> choiceColorNotifier = ValueNotifier(0);

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  int? initialPage;

  void goToHomeNav() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavBar()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    int percentage =
        100 - (widget.data.price / widget.data.actualPrice * 100.0).round();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kWhiteColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  widget.data.networkImageList!.length == 1
                      ? Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullImageScreen(
                                        imageUrl:
                                            widget.data.networkImageList!.first,
                                        id: widget.data.id!,
                                      ),
                                    ));
                              },
                              child: Hero(
                                tag: 'image_${widget.data.id}',
                                child: CachedNetworkImage(
                                  imageUrl: widget.data.networkImageList!.first,
                                  placeholder: (context, url) => Shimmer(
                                    color: kBlackColor,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      width: size.width,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/icons/no_image.svg'),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullImageScreen(
                                          imageUrl: widget
                                              .data.networkImageList!.first,
                                          id: widget.data.id!,
                                        ),
                                      ));
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/full_screen.svg',
                                  height: 24,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: IconButton(
                                // onPressed: () => goToHomeNav(),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  CupertinoIcons.back,
                                ),
                              ),
                            ),
                            widget.data.quantity == 0
                                ? Positioned(
                                    bottom: 15,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      color: Colors.black.withOpacity(0.6),
                                      child: const Text(
                                        'Out of Stock',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        )
                      : Stack(
                          children: [
                            Hero(
                              tag: 'image_${widget.data.id}',
                              child: FlutterCarousel(
                                items: List.generate(
                                  widget.data.networkImageList!.length,
                                  (index) => GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullImageScreen(
                                            imageList:
                                                widget.data.networkImageList!,
                                            isCarousal: true,
                                            id: widget.data.id!,
                                          ),
                                        )),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.data.networkImageList![index],
                                      placeholder: (context, url) => Shimmer(
                                        color: kBlackColor,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          width: size.width,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/icons/no_image.svg'),
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
                                    currentIndicatorColor: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullImageScreen(
                                          imageList:
                                              widget.data.networkImageList!,
                                          isCarousal: true,
                                          id: widget.data.id!,
                                        ),
                                      ));
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/full_screen.svg',
                                  height: 36,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: IconButton(
                                // onPressed: () => goToHomeNav(),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  CupertinoIcons.back,
                                ),
                              ),
                            ),
                            widget.data.quantity == 0
                                ? Positioned(
                                    bottom: 15,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      color: Colors.black.withOpacity(0.6),
                                      child: const Text(
                                        'Out of Stock',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
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
                                "${widget.data.brand} - ${widget.data.productName}",
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ),
                            WishlistButton(
                                searchList: widget.productList,
                                index: widget.index),
                          ],
                        ),
                        Text(
                          widget.data.description,
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${NumberFormat.decimalPattern().format(widget.data.price)}",
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$percentage%",
                              style: const TextStyle(
                                  fontSize: 18, color: offerPercentageColor),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "₹${NumberFormat.decimalPattern().format(widget.data.actualPrice)}",
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          width: size.width,
                          child: Text(
                            widget.data.longDescription,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Visibility(
                          visible: widget.data.networkImageList!.length != 1,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Color: ",
                                    style: TextStyle(
                                      color: kBlackColor,
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: choiceColorNotifier,
                                    builder: (context, selectedIndex, child) =>
                                        Text(
                                      widget
                                          .data.colorStringList![selectedIndex],
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
                                    widget.data.networkImageList!.length,
                                    (index) => ValueListenableBuilder(
                                          valueListenable: choiceColorNotifier,
                                          builder: (context, selectedIndex,
                                                  child) =>
                                              ChoiceChip(
                                                  // materialTapTargetSize:
                                                  //     MaterialTapTargetSize.shrinkWrap,
                                                  padding: EdgeInsets.zero,
                                                  backgroundColor: kWhiteColor,
                                                  selectedColor: kWhiteColor,
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
                                                          widget.data
                                                                  .networkImageList![
                                                              index],
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
                        // Row(
                        //   children: [
                        //     const Text("Type: "),
                        //     ValueListenableBuilder(
                        //       valueListenable: choiceTypeNotifier,
                        //       builder: (context, selectedIndex, child) => Text(
                        //         _dummyChipText[selectedIndex],
                        //         style: TextStyle(
                        //           color: Colors.grey[700],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: List.generate(
                        //     2,
                        //     (index) => ValueListenableBuilder(
                        //       valueListenable: choiceTypeNotifier,
                        //       builder: (context, selectedIndex, child) =>
                        //           Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 3),
                        //         child: ChoiceChip(
                        //           backgroundColor: kWhiteColor,
                        //           selectedColor: kWhiteColor,
                        //           shape: StadiumBorder(
                        //             side: selectedIndex != index
                        //                 ? const BorderSide(color: Colors.grey)
                        //                 : const BorderSide(color: kBlackColor),
                        //           ),
                        //           label: Text(
                        //             _dummyChipText[index],
                        //             style: TextStyle(
                        //               color: selectedIndex != index
                        //                   ? Colors.grey
                        //                   : kBlackColor,
                        //             ),
                        //           ),
                        //           selected: selectedIndex == index,
                        //           onSelected: (value) =>
                        //               choiceTypeNotifier.value = index,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: size.height * 0.1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Container(
              height: 60,
              decoration:
                  const BoxDecoration(border: Border(top: BorderSide())),
              width: size.width,
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final email = FirebaseAuth.instance.currentUser!.email;
                      List productIdList = [];
                      productIdList.add(widget.productList[widget.index].id);
                      CollectionReference collectionRef = FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(email)
                          .collection('cart');

                      QuerySnapshot querySnapshot = await collectionRef.get();
                      for (var document in querySnapshot.docs) {
                        document.reference.delete();
                      }

                      addToCart(
                          Cart(
                            productId: widget.data.id,
                            quantity: 1,
                            price: widget.data.price,
                            totalPrice: widget.data.price,
                          ),
                          context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            cartProductIdList: productIdList,
                            productList: widget.productList,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: SizedBox(
                      width: size.width * 0.45,
                      child: const Material(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Buy Now",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                // Text(
                                //   "",
                                //   style: TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AddToCartWidget(
                    data: widget.data,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
