import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class AddNewAddresScreen extends StatelessWidget {
  const AddNewAddresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainBgColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomAppBar(
                  title: "Add New Address", showBackButton: true),
              SizedBox(
                height: size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFieldWidget(
                      size: size,
                      fieldName: "Name",
                      colorValue: Colors.grey.withOpacity(0.2),
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "Pin Code",
                      colorValue: Colors.grey.withOpacity(0.2),
                      numPad: true,
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "Permanent Adress",
                      colorValue: Colors.grey.withOpacity(0.2),
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "State",
                      colorValue: Colors.grey.withOpacity(0.2),
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "City",
                      colorValue: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: size.width * 0.30, vertical: 20)),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
