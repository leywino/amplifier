import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/core/icons/custom_icon_icons.dart';
import 'package:amplifier/presentation/profile_screen/widgets/log_out_widget.dart';
import 'package:amplifier/presentation/profile_screen/widgets/profile_tile_widget.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  static final ValueNotifier<bool> showLogOutNotifier = ValueNotifier(false);

  final List<IconData> _profileIcons = [
    CustomIcon.profile_1iconfluttter,
    CustomIcon.locationiconfluttter,
    CustomIcon.locationiconfluttter,
    CustomIcon.notificationiconfluttter,
    CustomIcon.mooniconfluttter,
    CustomIcon.shieldiconfluttter,
    CustomIcon.document_align_left_5iconfluttter,
    CustomIcon.logouticonfluttter,
  ];

  final List<String> _profileTitles = [
    "Edit Profile",
    "Orders",
    "Address",
    "Notification",
    "Dark Mode",
    "Privacy Policy",
    "Terms & Conditions",
    "Log Out",
  ];

  final User? user = FirebaseAuth.instance.currentUser;
  final ValueNotifier<String> imagePathNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kMainBgColor,
          body: Column(
            children: [
              const CustomAppBar(title: "Profile", showBackButton: false),
              Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: user!.photoURL != null
                          ? Image.network(user!.photoURL!)
                          : GestureDetector(
                              onTap: () async {
                                final pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                if (pickedFile == null) {
                                  return;
                                } else {
                                  File file = File(pickedFile.path);
                                  imagePathNotifier.value =pickedFile.path;
                                      await _uploadImage(file, user!.email!);
                                }
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    user!.displayName ?? "no name",
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
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
                  profileIcons: _profileIcons, profileTitles: _profileTitles),
            ],
          ),
          bottomSheet: ValueListenableBuilder(
            valueListenable: showLogOutNotifier,
            builder: (context, showLogOut, child) => Visibility(
              visible: showLogOut,
              child: const LogOutWidget(),
            ),
          )),
    );
  }
}

_uploadImage(File file, String email) async {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref = storage.ref().child('pfp/$email');

  firebase_storage.UploadTask task = ref.putFile(file);

  await task;
  String imageUrl = await ref.getDownloadURL();
  final User? user =  FirebaseAuth.instance.currentUser;
  user!.updatePhotoURL(imageUrl);
}
