import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/colors/main_colors.dart';
import '../../../models/product_model.dart';
import '../../home_details_screen/main_home_details.dart';
import 'add_to_wishlist_button.dart';

class HomeProductTile extends StatelessWidget {
  const HomeProductTile({
    super.key,
    required this.searchList,
  });

  final List<Products> searchList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1 / 1.8,
      shrinkWrap: true,
      children: List.generate(searchList.length, (index) {
        int percentage =
            (searchList[index].price / searchList[index].actualPrice * 100.0)
                .round();

        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeDetailsPage(
                  data: searchList[index],
                  productList: searchList,
                  index: index,
                ),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  searchList[index].quantity == 0
                      ? Stack(
                          children: [
                            Hero(
                              tag: 'image_${searchList[index].id}',
                              child: CachedNetworkImage(
                                imageUrl:
                                    searchList[index].networkImageList![0],
                                placeholder: (context, url) => Shimmer(
                                  color: kBlackColor,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    width: size.width * 0.4,
                                    height: size.height * 0.195,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcATop,
                                  ),
                                  child:
                                      Image.asset('assets/icons/no_image.svg'),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              right: 8.0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.black.withOpacity(0.6),
                                child: const Text(
                                  'Out of Stock',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              child: Text(
                                "$percentage%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: offerPercentageColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Hero(
                              tag: 'image_${searchList[index].id}',
                              child: CachedNetworkImage(
                                imageUrl:
                                    searchList[index].networkImageList![0],
                                placeholder: (context, url) => Shimmer(
                                  color: kBlackColor,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    width: size.width * 0.4,
                                    height: size.height * 0.195,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/icons/no_image.svg'),
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              child: Text(
                                "$percentage%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: offerPercentageColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: WishlistButton(
                      searchList: searchList,
                      index: index,
                    ),
                  ),
                ],
              ),
              Text(
                searchList[index].brand,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                searchList[index].productName,
                style: const TextStyle(
                    fontSize: 18,
                    color: kTextBlackColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                searchList[index].description,
                style: const TextStyle(fontSize: 14, color: kTextBlackColor),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${NumberFormat.decimalPattern().format(searchList[index].price)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: kTextBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      width:
                          8), // Add some spacing between the actual price and percentage
                  Text(
                    "₹${NumberFormat.decimalPattern().format(searchList[index].actualPrice)}", // Replace with the actual price value
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

homeProductShimmerEffect() {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
    childAspectRatio: 1 / 1.8,
    shrinkWrap: true,
    children: List.generate(4, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            color: kBlackColor,
            child: Container(
              height: 180,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: kBlackColor,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: kBlackColor,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: kBlackColor,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: kBlackColor,
            child: const SizedBox(
              height: 30,
              width: 100,
            ),
          ),
        ],
      );
    }),
  );
}
