import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(30),
                color: Colors.black),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/bag.svg",
                      color: Colors.white,
                      height: 20,
                    ),
                  ),
                  Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}