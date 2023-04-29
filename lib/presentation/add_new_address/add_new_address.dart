import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddNewAddresScreen extends StatelessWidget {
  const AddNewAddresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppBar(title: "Edit Profile", showBackButton: true),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextFieldWidget(
                  size: size,
                  fieldName: "Name",
                  colorValue: Colors.grey.withOpacity(0.2),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFieldWidget(
                  size: size,
                  fieldName: "Email",
                  colorValue: Colors.grey.withOpacity(0.2),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                TextFieldWidget(
                  size: size,
                  fieldName: "Phone",
                  numPad: true,
                  colorValue: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: size.width * 0.30, vertical: 20)),
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}