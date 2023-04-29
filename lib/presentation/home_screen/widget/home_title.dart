import 'package:amplifier/core/colors/main_colors.dart';
import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Most Popular",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kTextBlackColor,
          ),
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              "SEE ALL",
              style: TextStyle(
                color: kTextBlackColor,
              ),
            ))
      ],
    );
  }
}
