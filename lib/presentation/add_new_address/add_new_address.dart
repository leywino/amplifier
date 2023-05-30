import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/models/address_model.dart';
import 'package:amplifier/models/functions.dart';
import 'package:amplifier/presentation/address_screen/address_screen.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class AddNewAddresScreen extends StatelessWidget {
  AddNewAddresScreen({super.key, this.fromCheckOut = false});

  final bool fromCheckOut;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

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
              const CustomAppBar(
                  title: "Add New Address", showBackButton: true),
              Form(
                key: _formKey,
                child: SizedBox(
                  height: size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFieldWidget(
                        size: size,
                        fieldName: "Name",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: nameController,
                        validator: _nameValidator,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "Pin Code",
                        colorValue: Colors.grey.withOpacity(0.2),
                        numPad: true,
                        textController: pincodeController,
                        validator: _pincodeValidator,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "Permanent Adress",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: addressController,
                        validator: _addressValidator,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "State",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: stateController,
                        validator: _stateValidator,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "City",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: cityController,
                        validator: _cityValidator,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.2,
              ),
              SizedBox(
                width: size.width * 0.8,
                child: TextButton(
                  onPressed: () async {
                    final form = _formKey.currentState!.validate();
                    if (form) {
                      await addAddress(
                          Address(
                            name: nameController.text.trim(),
                            pinCode: int.parse(pincodeController.text.trim()),
                            permanentAddress: addressController.text.trim(),
                            state: stateController.text.trim(),
                            defaultAddressBool: false,
                            city: cityController.text.trim(),
                          ),
                          context);

                      !fromCheckOut
                          // ignore: use_build_context_synchronously
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) =>
                                    const AddressScreen(),
                              ),
                              (route) => route.isFirst,
                            )
                          // ignore: use_build_context_synchronously
                          : Navigator.pop(context);
                    }
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
                        'Add',
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

  String? _nameValidator(String? value) {
    if (nameController.text.trim().isEmpty) {
      return 'This field cant be emtpy';
    }
    return null;
  }

  String? _addressValidator(String? value) {
    if (addressController.text.trim().isEmpty) {
      return 'This field cant be emtpy';
    }
    return null;
  }

  String? _pincodeValidator(String? value) {
    if (pincodeController.text.trim().isEmpty) {
      return 'This field cant be emtpy';
    }
    return null;
  }

  String? _stateValidator(String? value) {
    if (stateController.text.trim().isEmpty) {
      return 'This field cant be emtpy';
    }
    return null;
  }

  String? _cityValidator(String? value) {
    if (cityController.text.trim().isEmpty) {
      return 'This field cant be emtpy';
    }
    return null;
  }
}
