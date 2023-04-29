import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/categories_screen/widgets/categories_tile.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kMainBgColor,
      body: Column(
        children: [
          const CustomAppBar(
            title: "Categories",
            showBackButton: false,
          ),
          Column(
            children: List.generate(5, (index) => CategoriesTile(index: index,)),
          ),
        ],
      ),
    ));
  }
}
