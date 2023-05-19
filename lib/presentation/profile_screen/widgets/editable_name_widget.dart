import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditableTextWidget extends StatefulWidget {
  const EditableTextWidget({super.key, required this.user});

  final User user;
  @override
  _EditableTextWidgetState createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  bool isEditing = false;
  TextEditingController textEditingController = TextEditingController();
  String editedText = '';

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.user!.displayName!;
    editedText = widget.user!.displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isEditing = true;
            });
          },
          child: Text(
            editedText,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isEditing = true;
              });
            },
            child: const Icon(Icons.edit),
          ),
        ),
        if (isEditing)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      editedText = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
