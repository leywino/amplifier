// ignore_for_file: deprecated_member_use

import 'package:amplifier/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:amplifier/presentation/profile_screen/main_profile_screen.dart';
import 'package:amplifier/presentation/profile_screen/widgets/log_out_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../address_screen/address_screen.dart';
import '../../order_screen/order_screen.dart';

class ProfileTileWidget extends StatelessWidget {
  ProfileTileWidget({
    super.key,
    required List<IconData> profileIcons,
    required List<String> profileTitles,
  })  : _profileIcons = profileIcons,
        _profileTitles = profileTitles;

  final List<IconData> _profileIcons;
  final List<String> _profileTitles;
  final _profilePages = [
    const EditProfileScreen(),
    const OrderScreen(),
    AddressScreen(),
    const LogOutWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          index != 7
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        index != 7 ? _profilePages[index] : _profilePages[3],
                  ))
              : ProfileScreen.showLogOutNotifier.value = true;
        },
        leading: index != 1
            ? Icon(
                _profileIcons[index],
                color: index != 7 ? Colors.black : Colors.red,
              )
            : SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  "assets/icons/checkout.svg",
                  height: 30,
                  color: Colors.black,
                ),
              ),
        title: Text(
          _profileTitles[index],
          style: index != 7
              ? const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              : const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
        ),
        trailing: index != 7
            ? Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
