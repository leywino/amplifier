import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_cart_screen.dart';

class QuantityCartWidget extends StatelessWidget {
  const QuantityCartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 30,
      // width: 1,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
        width: size.width * 0.2,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                quantityNotifier.value--;
              },
              child: const Icon(
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
            GestureDetector(
              onTap: () {
                quantityNotifier.value++;
              },
              child: const Icon(
                CupertinoIcons.add,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
