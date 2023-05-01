import 'dart:developer';

import 'package:amplifier/presentation/signup_screen/signup_screen.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field_widget.dart';

class MainLoginScreen extends StatelessWidget {
  MainLoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateEmailField(String? value) {
    if (emailController.text.trim().isEmpty) {
      return 'Email field is empty';
    } else if (!EmailValidator.validate(emailController.text.trim())) {
      return 'Enter valid email';
    }
    return null;
  }

  String? _validatePasswordField(String? value) {
    if (passwordController.text.trim().isEmpty) {
      return 'Password field is empty';
    } else if (passwordController.text.trim().length < 8) {
      return 'Enter minimum 8 characters';
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
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: size.height * 0.2,
                      color: Colors.black,
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset("assets/icons/logo_white.png"),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: size.height * 0.8,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 236, 236, 236),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(150),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            TextFieldWidget(
                              size: size,
                              validator: _validateEmailField,
                              fieldName: "Email",
                              textController: emailController,
                            ),
                            // SizedBox(
                            //   height: size.height * 0.005,
                            // ),
                            Stack(
                              children: [
                                TextFieldWidget(
                                  size: size,
                                  fieldName: "Password",
                                  validator: _validatePasswordField,
                                  hideField: true,
                                  textController: passwordController,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            TextButton(
                              onPressed: () {
                                signIn(context);
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: size.width * 0.32,
                                        vertical: 20)),
                              ),
                              child: const Text(
                                'Login',
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
                            TextButton(
                              onPressed: () {
                                _showMySnackBar(context);
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal: size.width * 0.16,
                                        vertical: 20)),
                              ),
                              child: const Text(
                                'Login with Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Don't have an account yet? ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: Colors.black,
                                      // decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MainSignupScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Forgot password? ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Reset Now",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Add your code for password reset functionality
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

  Future signIn(BuildContext context) async {
    final form = _formKey.currentState!.validate();
    if (form) {
      try {
        print(emailController.text.trim());
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        log(e.toString());
      }
    }
  }

  void _showMySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text(
          'This is a demo SnackBar. Would you like to approve of this message?'),
      action: SnackBarAction(
        label: 'Approve',
        onPressed: () {
          // Perform some action
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
