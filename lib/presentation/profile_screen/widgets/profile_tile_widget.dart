import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget({
    super.key,
    required List<IconData> profileIcons,
    required List<String> profileTitles,
  }) : _profileIcons = profileIcons, _profileTitles = profileTitles;

  final List<IconData> _profileIcons;
  final List<String> _profileTitles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
        leading: index != 1
            ? Icon(
                _profileIcons[index],
                color: index != 7 ? Colors.black : Colors.red,
              )
            : SizedBox(
                child: SvgPicture.asset(
                  "assets/icons/checkout.svg",
                  height: 30,
                  color: Colors.black,
                ),
                height: 24,
                width: 24,
              ),
        title: Text(
          _profileTitles[index],
          style: index != 7
              ? TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              : TextStyle(
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
                child: Center(
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
