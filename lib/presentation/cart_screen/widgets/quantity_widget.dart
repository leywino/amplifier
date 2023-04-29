import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_cart_screen.dart';

class QuantityCartWidget extends StatelessWidget {
  const QuantityCartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      // width: 1,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              quantityNotifier.value--;
            },
            icon: Icon(
              CupertinoIcons.minus,
              size: 16,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ValueListenableBuilder(
                valueListenable: quantityNotifier,
                builder: (context, quantityValue, child) =>
                    Text("$quantityValue"),
              )),
          IconButton(
            onPressed: () {
              quantityNotifier.value++;
            },
            icon: Icon(
              CupertinoIcons.add,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
