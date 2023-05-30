// ignore_for_file: deprecated_member_use

import 'package:amplifier/presentation/profile_screen/widgets/privacy_and_terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/colors/main_colors.dart';
import '../../address_screen/address_screen.dart';
import '../../login_screen/login_screen.dart';
import '../../login_screen/widgets/forgot_password.dart';
import '../../order_screen/order_screen.dart';
import '../main_profile_screen.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget({
    super.key,
    required List<IconData> profileIcons,
    required List<String> profileTitles,
  })  : _profileIcons = profileIcons,
        _profileTitles = profileTitles;

  final List<IconData> _profileIcons;
  final List<String> _profileTitles;

  @override
  Widget build(BuildContext context) {
    final profilePages = [
       OrderScreen(),
      const AddressScreen(),
      SettingsMenuPop(
        mdFileName: 'privacy.md',
      ),
    ];
    return ListView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if (index == 4) {
            _showBottomModalSheet(context);
          }
          if (index == 0 || index == 1) {
            index != 4
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          index != 4 ? profilePages[index] : profilePages[2],
                    ))
                : ProfileScreen.showLogOutNotifier.value = true;
          } else if (index == 2 || index == 3) {
            index == 2
                ? showDialog(
                    context: context,
                    builder: (builder) {
                      return SettingsMenuPop(mdFileName: 'privacy.md');
                    })
                : showDialog(
                    context: context,
                    builder: (builder) {
                      return SettingsMenuPop(mdFileName: 'terms.md');
                    });
          }
        },
        leading: index != 1
            ? Icon(
                _profileIcons[index],
                color: index != 4 ? kBlackColor : Colors.red,
              )
            : SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  "assets/icons/checkout.svg",
                  height: 30,
                  color: kBlackColor,
                ),
              ),
        title: Text(
          _profileTitles[index],
          style: index != 4
              ? const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor,
                )
              : const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
        ),
        trailing: (index != 4)
            ? Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kBlackColor, width: 1.0),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 16,
                    color: kBlackColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

showPopUp(BuildContext context, String mdFileName) {
  showDialog(
      context: context,
      builder: (builder) {
        return SettingsMenuPop(mdFileName: mdFileName);
      });
}

void _showBottomModalSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
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
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ProfileScreen.showLogOutNotifier.value = false;
                    Navigator.pop(context);
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
    },
  );
}
