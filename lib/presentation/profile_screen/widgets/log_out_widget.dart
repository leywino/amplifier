import 'package:amplifier/presentation/login_screen/login_screen.dart';
import 'package:amplifier/presentation/profile_screen/main_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/colors/main_colors.dart';
import '../../widgets/snackbar.dart';

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Log Out',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  ProfileScreen.showLogOutNotifier.value = false;
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kWhiteColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: kBlackColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showEmailSentSnackbar(context, "Logged Out");
                  ProfileScreen.showLogOutNotifier.value = false;
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration.zero,
                      pageBuilder: (_, __, ___) => MainLoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kBlackColor),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                  child: Text(
                    'Yes, Logout',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
