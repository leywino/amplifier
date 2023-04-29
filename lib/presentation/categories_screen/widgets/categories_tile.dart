import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesTile extends StatelessWidget {
  CategoriesTile({super.key, required this.index});

  final int index;

  final dummyCategoryName = [
    "Headphones",
    "In-Ears",
    "Wireless",
    "DACS & Amps",
    "Hi-Res Audio Players",
  ];
  final dummyCategoryImage = [
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-HiFiMAN-HE400se-1160-1160-7.jpg?v=1614245064&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/KZ-ZSN-Pro-X-Black-01_960774c7-2c57-4f9c-ab41-12cff3d684de.jpg?v=1650864564&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sony-WF-1000XM4-Black-07.jpg?v=1642060231&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/astell-kern-ak-xb10-headphone-zone-13983714246719.jpg?v=1589284696&width=800",
    "https://cdn.shopify.com/s/files/1/0153/8863/products/Headphone-Zone-Sony-NW-ZX707-012.jpg?v=1674635770&width=800",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(dummyCategoryImage[index]),
        title: Text(
          dummyCategoryName[index],
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.chevron_forward,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
