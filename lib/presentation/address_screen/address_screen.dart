import 'dart:developer';
import 'package:amplifier/core/colors/main_colors.dart';
import 'package:amplifier/presentation/add_new_address/edit_address_screen.dart';
import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../models/address_model.dart';
import '../../models/functions.dart';
import '../add_new_address/add_new_address.dart';

final ValueNotifier<int> radioNotifier = ValueNotifier(0);

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int? trueIndex;
  @override
  void initState() {
    super.initState();
    fetchTrueIndex();
  }

  void fetchTrueIndex() {
    final String email = FirebaseAuth.instance.currentUser!.email!;
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('address')
        .get()
        .then((QuerySnapshot querySnapshot) {
      final documents = querySnapshot.docs;
      for (int i = 0; i < documents.length; i++) {
        final booleanValue = documents[i]['defaultAddressBool'] ?? false;
        if (booleanValue) {
          setState(() {
            trueIndex = i;
          });
          break;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      radioNotifier.value = trueIndex ?? 0;
    });
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kMainBgColor,
          body: SingleChildScrollView(
            child: Column(children: [
              const CustomAppBar(
                title: "Address",
                showBackButton: true,
                showTrailingIcon: true,
                goToProfileScreen: true,
              ),
              StreamBuilder(
                stream: getAddress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const CircularProgressIndicator();
                    log(snapshot.data.toString());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.data == null) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Shimmer(
                          color: Colors.black,
                          child: const SizedBox(
                            height: 70,
                            width: double.infinity,
                          )),
                    );
                  }
                  List<DocumentSnapshot> documents = snapshot.data!;
                  List<Address> addressList = convertToAddressList(documents);

                  return Column(
                    children: List.generate(
                      addressList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                12.0), // set the border radius to 12.0
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditAdressScreen(
                                        data: addressList[index]),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[400],
                                child: SvgPicture.asset(
                                    "assets/icons/location.svg"),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addressList[index].name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  FittedBox(
                                    child: Text(
                                      '${addressList[index].state!}, ${addressList[index].city!}, ${addressList[index].pinCode}',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ValueListenableBuilder(
                                  valueListenable: radioNotifier,
                                  builder: (context, radioIndex, child) {
                                    if (radioIndex == 10) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDeleteConfirmationDialog(
                                                context,
                                                addressList[index].id!);
                                          },
                                          child: SvgPicture.asset(
                                              'assets/icons/delete.svg'),
                                        ),
                                      );
                                    } else {
                                      return Radio(
                                        value: radioIndex == index,
                                        groupValue: true,
                                        onChanged: (value) async {
                                          radioNotifier.value = index;

                                          updateRadioButtonValue(
                                              addressList[index].id!);
                                        },
                                        activeColor: Colors.black,
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: size.height * 0.35,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ]),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewAddresScreen(),
                        ));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.grey.withOpacity(0.4)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: size.width * 0.195, vertical: 20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset("assets/icons/location.svg"),
                      const Text(
                        'Add New Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  showDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteFromAddress(documentId);
                setState(() {});
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
