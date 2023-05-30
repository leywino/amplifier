// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:amplifier/presentation/login_screen/widgets/forgot_password.dart';
import 'package:amplifier/presentation/signup_screen/signup_screen.dart';
import 'package:amplifier/presentation/widgets/bottom_navigation_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/colors/main_colors.dart';
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

  Future<bool> checkIfInternetIsAvailable() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: checkIfInternetIsAvailable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (snapshot.data == false) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'No internet available\nTurn on wifi or mobile data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        }
        return SafeArea(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: kBlackColor,
                  body: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: size.height * 0.2,
                          color: kBlackColor,
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
                                  onPressed: () async {
                                    bool isLogin = await signIn(context);
                                    if (isLogin == true) {
                                      showEmailSentSnackbar(
                                          context, "Successfully Signed In");
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            color: kBlackColor),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kBlackColor),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.symmetric(
                                                horizontal: size.width * 0.32,
                                                vertical: 20)),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: kWhiteColor,
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
                                  onPressed: () => loginWithGoogle(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kWhiteColor),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: size.width * 0.12,
                                          vertical: 20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Login with Google',
                                        style: TextStyle(
                                          color: kBlackColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: SvgPicture.asset(
                                              'assets/icons/google_logo.svg'),
                                        ),
                                      ),
                                    ],
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
                                        style: const TextStyle(
                                          color: kBlackColor,
                                          // decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainSignupScreen(),
                                              ),
                                              (route) => false,
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
                                        style: const TextStyle(
                                          color: kBlackColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ResetPasswordScreen(),
                                              ),
                                            );
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
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavBar(),
                    ),
                    (route) => false,
                  ),
                );
              }

              return Container(
                color: kBlackColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        return true;
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        showEmailSentSnackbar(context, e.toString());
        return false;
      }
    }
  }
}

loginWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  await FirebaseAuth.instance.signInWithCredential(credential);
}
