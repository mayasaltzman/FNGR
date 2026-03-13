import 'package:flutter/material.dart';

abstract class ProfileStyles {
  static const formPadding = 20.0;

  static TextStyle pageHeader(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primaryFixed,
      fontSize: 25,
    );
  }

  static ButtonStyle nextButton(BuildContext context) {
    return ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        foregroundColor: Theme.of(context).colorScheme.secondaryFixed,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10));
  }

}
