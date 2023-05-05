import 'package:flutter/material.dart';

void showEmailSentSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    // action: SnackBarAction(
    //   label: 'Dismiss',
    //   onPressed: () {
    //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   },
    // ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
