import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/strings.dart';
import 'category_specific_grid.dart';

class CategoriesTile extends StatelessWidget {
  const CategoriesTile({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategorySpecificGrid(
                    categoryTitle: dummyCategoryName[index],
                    categoryFirebaseName: categoryFirebaseName[index]),
              ));
        },
        leading: SizedBox(
            height: 50,
            child: CachedNetworkImage(
              imageUrl: dummyCategoryImage[index],
              placeholder: (context, url) => Shimmer(
                color: Colors.black,
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  height: 50,
                  width: 50,
                ),
              ),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/icons/no_image.svg'),
            )),
        title: Text(
          dummyCategoryName[index],
          style: const TextStyle(
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
          child: const Center(
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
