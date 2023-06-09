import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/presentation/profile_screen/widgets/log_out_widget.dart';
import 'package:amplifier/presentation/profile_screen/widgets/profile_tile_widget.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../core/strings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static final ValueNotifier<bool> showLogOutNotifier = ValueNotifier(false);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final TextEditingController nameController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImage;
  bool enableTextField = false;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    nameController.text = user!.displayName!;
    profileImage = user!.photoURL ??
        "https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png";
    super.initState();
  }

  final List<IconData> _profileIcons = [
    CustomIcon.locationiconfluttter,
    CustomIcon.locationiconfluttter,
    CustomIcon.shieldiconfluttter,
    CustomIcon.document_align_left_5iconfluttter,
    CustomIcon.logouticonfluttter,
  ];

  User? user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: kWhiteColor,
          body: Column(
            children: [
              const CustomAppBar(title: "Profile", showBackButton: false),
              Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                        child: GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (pickedFile == null) {
                          return;
                        } else {
                          File file = File(pickedFile.path);

                          await _uploadImage(file, user!.email!);
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: profileImage!,
                        placeholder: (context, url) => Shimmer(
                          color: kBlackColor,
                          child: Container(
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/icons/no_image.svg'),
                      ),
                    )),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: Center(
                            child: TextField(
                              onSubmitted: (value) {
                                user!.updateDisplayName(
                                    nameController.text.trim());
                              },
                              enabled: enableTextField,
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                              ),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              enableTextField = !enableTextField;
                            });
                            !enableTextField
                                ? user!.updateDisplayName(nameController.text)
                                : null;
                          },
                          icon: !enableTextField
                              ? SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  height: 20,
                                )
                              : SvgPicture.asset(
                                  'assets/icons/check.svg',
                                  height: 20,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 8.0),
                ],
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.7,
                indent: 25,
                endIndent: 25,
              ),
              const SizedBox(height: 8.0),
              ProfileTileWidget(
                  profileIcons: _profileIcons, profileTitles: profileTitles),
            ],
          ),
          bottomSheet: ValueListenableBuilder(
            valueListenable: ProfileScreen.showLogOutNotifier,
            builder: (context, showLogOut, child) => Visibility(
              visible: showLogOut,
              child: const LogOutWidget(),
            ),
          )),
    );
  }

  _uploadImage(File file, String email) async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference ref = storage.ref().child('pfp/$email');

    firebase_storage.UploadTask task = ref.putFile(file);

    await task;
    String imageUrl = await ref.getDownloadURL();
    final User? user = FirebaseAuth.instance.currentUser;
    await user!.updatePhotoURL(imageUrl);
    setState(() {
      profileImage = imageUrl;
    });
  }
}
