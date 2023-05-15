import 'package:flutter/material.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: lightNotifier,
      builder: (context, light, child) => Switch(
        // This bool value toggles the switch.
        value: light,
        activeColor: Colors.grey,
        onChanged: (bool change) {
          // This is called when the user toggles the switch.
          lightNotifier.value = change;
        },
      ),
    );
  }
}

ValueNotifier<bool> lightNotifier = ValueNotifier(true);
