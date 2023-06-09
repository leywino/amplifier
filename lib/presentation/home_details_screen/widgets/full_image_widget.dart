import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/colors/main_colors.dart';

class FullImageScreen extends StatefulWidget {
  const FullImageScreen({
    super.key,
    this.imageUrl,
    this.isCarousal = false,
    this.imageList,
    required this.id,
  });
  final String? imageUrl;
  final bool isCarousal;
  final List? imageList;
  final String id;

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBlackColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: kWhiteColor,
          ),
        ),
      ),
      backgroundColor: kBlackColor,
      body: !widget.isCarousal
          ? Center(
              child: SizedBox(
                height: size.width,
                width: size.width,
                child: Hero(
                  tag: 'image_${widget.id}',
                  child: PhotoView(
                    imageProvider: NetworkImage(widget.imageUrl!),
                  ),
                ),
              ),
            )
          : PageView(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          // Swiped from left to right
                          selectedIndex--;
                          if (selectedIndex > 0) {
                            setState(() {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          }
                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                          // Swiped from right to left
                          if (selectedIndex < widget.imageList!.length - 1) {
                            setState(() {
                              selectedIndex++;
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          }
                        }
                      },
                      child: SizedBox(
                        height: size.height * 0.8,
                        width: size.width,
                        child: PageView.builder(
                          onPageChanged: (value) {
                            setState(() {
                              selectedIndex = value;
                            });
                          },
                          controller: _pageController,
                          itemCount: widget.imageList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              child: Hero(
                                tag: 'image_${widget.id}',
                                child: PhotoView(
                                    imageProvider:
                                        NetworkImage(widget.imageList![index])),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.imageList!.length,
                        (index) => ChoiceChip(
                            labelPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                            // materialTapTargetSize:
                            //     MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            backgroundColor: kBlackColor,
                            selectedColor: kBlackColor,
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.fromBorderSide(
                                      selectedIndex != index
                                          ? const BorderSide(
                                              width: 1,
                                              color: Colors.grey,
                                            )
                                          : const BorderSide(
                                              width: 2,
                                              color: kBlackColor,
                                            )),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.imageList![index],
                                    ),
                                  ),
                                ),
                                width: selectedIndex != index ? 50 : 70,
                                height: selectedIndex != index ? 50 : 70,
                              ),
                            ),
                            selected: selectedIndex == index,
                            onSelected: (value) {
                              updateSelectedIndex(index);
                            }),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
