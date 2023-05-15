import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/colors/main_colors.dart';
import '../../home_details_screen/main_home_details.dart';
import 'add_to_wishlist_button.dart';

class HomeProductTile extends StatelessWidget {
  const HomeProductTile({
    super.key,
    required this.searchList,
  });

  final List searchList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1 / 1.8,
      shrinkWrap: true,
      children: List.generate(searchList.length, (index) {
        int percentage = (searchList[index]['price'] /
                searchList[index]['actualPrice'] *
                100.0)
            .round();

        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeDetailsPage(data: searchList[index]),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  searchList[index]['networkImageList'] != null
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  searchList[index]['networkImageList'][0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 180,
                        )
                      : const CircularProgressIndicator(),
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
                searchList[index]['brand'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                searchList[index]['productName'],
                style: const TextStyle(
                    fontSize: 18,
                    color: kTextBlackColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                searchList[index]['description'],
                style: const TextStyle(fontSize: 14, color: kTextBlackColor),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${NumberFormat.decimalPattern().format(searchList[index]['price'])}",
                    style: const TextStyle(
                        fontSize: 18,
                        color: kTextBlackColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$percentage%",
                    style: const TextStyle(
                        fontSize: 10, color: offerPercentageColor),
                  )
                ],
              )
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
            color: Colors.black,
            child: Container(
              height: 180,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: Colors.black,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: Colors.black,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: Colors.black,
            child: Container(
              height: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer(
            color: Colors.black,
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
