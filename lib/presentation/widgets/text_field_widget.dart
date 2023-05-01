import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.size,
    required this.fieldName,
    this.hideField = false,
    this.numPad = false,
    this.colorValue = Colors.white,
    required this.textController,
    this.validator,
    this.hintName,
    this.enabled = true,
  }) : super(key: key);

  final Size size;
  final String fieldName;
  final bool hideField;
  final bool enabled;
  final bool numPad;
  final Color colorValue;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final String? hintName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorValue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(
                fieldName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              TextFormField(
                validator: validator,
                enabled: enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: textController,
                obscureText: hideField,
                keyboardType: numPad ? TextInputType.phone : null,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hintName ?? "Type here",
                  border: InputBorder.none,
                  labelStyle: const TextStyle(
                    color: Colors.transparent,
                  ),
                  // errorBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //     color: Colors.red,
                  //     width: 1.0,
                  //   ),
                  //   borderRadius: BorderRadius.circular(15.0),
                  // ),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  // contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
