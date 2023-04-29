import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/order_screen/widgets/active_tile_widget.dart';
import 'package:amplifier/presentation/order_screen/widgets/complete_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainBgColor,
          elevation: 0,
          // automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back),
          ),
          title: const Text(
            "My Orders",
            style: TextStyle(
              color: kTextBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: kTextBlackColor,
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Complete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: kTextBlackColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
            unselectedLabelColor: Colors.grey,
            labelColor: kTextBlackColor,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: ActiveTileWidget(size: size),
            ),
            SingleChildScrollView(
              child: CompletedTileWidget(size: size),
            ),
          ],
        ),
      ),
    );
  }
}
