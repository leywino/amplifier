import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/address_model.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

import '../address_screen/address_screen.dart';

class EditAdressScreen extends StatefulWidget {
  const EditAdressScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<EditAdressScreen> createState() => _EditAdressScreenState();
}

class _EditAdressScreenState extends State<EditAdressScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  final TextEditingController stateController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.data['name'];
    addressController.text = widget.data['permanent address'];
    pincodeController.text = widget.data['pin code'].toString();
    stateController.text = widget.data['state'];
    cityController.text = widget.data['city'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomAppBar(title: "Edit Address", showBackButton: true),
              SizedBox(
                height: size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFieldWidget(
                      size: size,
                      fieldName: "Name",
                      colorValue: Colors.grey.withOpacity(0.2),
                      textController: nameController,
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "Pin Code",
                      colorValue: Colors.grey.withOpacity(0.2),
                      numPad: true,
                      textController: pincodeController,
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "Permanent Adress",
                      colorValue: Colors.grey.withOpacity(0.2),
                      textController: addressController,
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "State",
                      colorValue: Colors.grey.withOpacity(0.2),
                      textController: stateController,
                    ),
                    TextFieldWidget(
                      size: size,
                      fieldName: "City",
                      colorValue: Colors.grey.withOpacity(0.2),
                      textController: cityController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: TextButton(
                  onPressed: () async {
                    await updateAddress(
                        Address(
                          name: nameController.text.trim(),
                          pinCode: int.parse(pincodeController.text.trim()),
                          permanentAddress: addressController.text.trim(),
                          state: stateController.text.trim(),
                          defaultAddressBool: false,
                          city: cityController.text.trim(),
                        ),
                        context,
                        widget.data['id']);

                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const AddressScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: kBlackColor),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kBlackColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save',
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
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
