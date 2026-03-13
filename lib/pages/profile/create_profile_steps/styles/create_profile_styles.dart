import 'package:flutter/material.dart';

abstract class ProfileStyles {
  static const formPadding = 20.0;
  static const spacing = 30.0;
  static const dialogueHeight = 150.0;

  static TextStyle pageHeader(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primaryFixed,
      fontSize: 25,
    );
  }

  static TextStyle dialogueText(BuildContext context) {
    return TextStyle(color: Theme.of(context).colorScheme.primaryFixed);
  }

  static TextStyle subText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.primaryFixed, fontSize: 15);
  }

  static ButtonStyle nextButton(BuildContext context) {
    return ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        foregroundColor: Theme.of(context).colorScheme.secondaryFixed,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10));
  }

  static ButtonStyle textButton(BuildContext context) {
    return TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primaryFixed,
        textStyle: const TextStyle(
            decoration: TextDecoration.underline, fontSize: 15));
  }

  static ButtonStyle saveButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      foregroundColor: Theme.of(context).colorScheme.secondaryFixed,
      fixedSize: const Size(150, 50),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
