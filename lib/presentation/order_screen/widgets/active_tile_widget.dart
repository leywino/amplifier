import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ActiveTileWidget extends StatelessWidget {
  const ActiveTileWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 100,
                    width: 100,
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/leywin-amplifier.appspot.com/o/images%2Fchu?alt=media&token=c9313e96-0b5f-4116-8030-a268c7c47e36',
                    placeholder: (context, url) => Shimmer(
                      color: Colors.black,
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        width: size.width,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/icons/no_image.svg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Product Description',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  orderCancelConfirm(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Track',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

orderCancelConfirm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Cancel Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Are you sure you want to cancel this order?',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context, false); // Return false if cancel is pressed
                    },
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context, true); // Return true if confirm is pressed
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
