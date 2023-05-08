import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/colors/main_colors.dart';
import '../../../core/icons/genereal_icons.dart';
import '../../home_details_screen/main_home_details.dart';

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
                  searchList[index]['networkImageString'] != null
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  searchList[index]['networkImageString']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 180,
                        )
                      : const CircularProgressIndicator(),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: SizedBox(
                        height: 22,
                        width: 22,
                        child: cHeartIcon,
                      ),
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
                  const Text(
                    "%",
                    style: TextStyle(fontSize: 10, color: offerPercentageColor),
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
