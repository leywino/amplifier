import 'package:amplifier/core/colors/main_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCartScreen extends StatelessWidget {
  const MainCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainBgColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          leading: Icon(CupertinoIcons.back),
        ),
      ),
    );
  }
}
