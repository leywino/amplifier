import 'dart:developer';
import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:amplifier/presentation/widgets/text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> editNotifier = ValueNotifier(false);
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  String? _validateNameField(String? value) {
    if (nameController.text.trim().isEmpty) {
      return 'Name field is empty';
    } else if (nameController.text.trim().length < 4) {
      return 'Enter minimum 4 characters';
    }
    return null;
  }

  String? _validateEmailField(String? value) {
    if (emailController.text.trim().isEmpty) {
      return 'Email field is empty';
    } else if (!EmailValidator.validate(emailController.text.trim())) {
      return 'Enter valid email';
    }
    return null;
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
              const CustomAppBar(title: "Edit Profile", showBackButton: true),
              Form(
                key: _formKey,
                child: ValueListenableBuilder(
                  valueListenable: editNotifier,
                  builder: (context, editOrUpdate, child) => Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "Name",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: nameController,
                        hintName: user!.displayName,
                        enabled: editOrUpdate,
                        validator: _validateNameField,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      TextFieldWidget(
                        size: size,
                        fieldName: "Email",
                        colorValue: Colors.grey.withOpacity(0.2),
                        textController: emailController,
                        hintName: user!.email,
                        enabled: editOrUpdate,
                        validator: _validateEmailField,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.3,
              ),
              ValueListenableBuilder(
                valueListenable: editNotifier,
                builder: (context, editOrUpdate, child) => TextButton(
                  onPressed: () {
                    editNotifier.value = !editNotifier.value;
                    editOrUpdate ? _updateProfile(context) : null;
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
                        EdgeInsets.symmetric(
                            horizontal: size.width * 0.30, vertical: 20)),
                  ),
                  child: Text(
                    !editOrUpdate ? 'Edit' : 'Update',
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _updateProfile(BuildContext context) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(child: CircularProgressIndicator()),
    // );

    final form = _formKey.currentState!.validate();
    if (form) {
      try {
        await user!.updateDisplayName(nameController.text.trim());
        await user!.updateEmail(emailController.text.trim());
      } on FirebaseAuthException catch (e) {
        log(e.toString());
      }
    } else {
      editNotifier.value = !editNotifier.value;
    }
  }
}
