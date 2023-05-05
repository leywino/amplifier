import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_field_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          const Text(
                            'Reset Password ',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.2,
                          ),
                          TextFieldWidget(
                            size: size,
                            validator: _validateEmailField,
                            fieldName: "Email",
                            textController: emailController,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),

                          TextButton(
                            onPressed: () {
                              resetPassword(context);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: size.width * 0.22,
                                      vertical: 20)),
                            ),
                            child: const Text(
                              'Send Mail',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: size.height * 0.01,
                          // ),
                          // const Text(
                          //   'OR',
                          //   style: TextStyle(
                          //     fontSize: 24.0,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: size.height * 0.02,
                          // ),

                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Go back to ",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: size.height * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            Future.delayed(
              const Duration(milliseconds: 100),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavBar(),
                ),
              ),
            );
          }

          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  // Future signIn(BuildContext context) async {
  //   final form = _formKey.currentState;
  //   if (form != null) {
  //     if (form.validate()) {
  //       form.save();
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) =>
  //             const Center(child: CircularProgressIndicator()),
  //       );
  //       try {
  //         print(emailController.text.trim());
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //             email: emailController.text.trim(),
  //             password: passwordController.text.trim());
  //       } on FirebaseAuthException catch (e) {
  //         log(e.toString());
  //       }
  //     } else {}
  //   }

  //   Future.delayed(
  //     Duration(seconds: 2),
  //     () => _formKey.currentState?.reset(),
  //   );
  // }

  Future resetPassword(BuildContext context) async {
    final form = _formKey.currentState!.validate();
    if (form) {
      try {
        showEmailSentSnackbar(context, "Email sent successfully");
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        showEmailSentSnackbar(context, e.toString());
      }
    }
  }
}

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
