import 'package:amplifier/presentation/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field_widget.dart';

class MainLoginScreen extends StatelessWidget {
  const MainLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
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
                    fieldName: "Email",
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldWidget(
                    size: size,
                    fieldName: "Password",
                    hideField: true,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainSignupScreen(),
                          ));
                    },
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
                              horizontal: size.width * 0.32, vertical: 20)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                              horizontal: size.width * 0.16, vertical: 20)),
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
                  TextButton(
                    onPressed: () {
                      // Your onTap logic here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 236, 236, 236)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Don't have an account? Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
