import 'package:amplifier/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CustomAppBar(title: "Address", showBackButton: true),
        Column(
          children: List.generate(
            1,
            (index) => ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              trailing: Radio(
                value: true,
                groupValue: true,
                onChanged: (value) {},
                activeColor: Colors.black,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
