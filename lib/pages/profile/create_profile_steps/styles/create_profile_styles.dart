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

  static TextStyle inputHeader(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primaryFixed,
        fontSize: 18);
  }

  static TextStyle inputText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.primaryFixed, fontSize: 16);
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

  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      labelStyle: inputText(context),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primaryFixed),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primaryFixed,
          width: 2,
        ),
      ),
    );
  }

  static InputDecoration bioInputDecoration(
    BuildContext context,
    String? label,
    int remaining,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: inputText(context),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primaryFixed,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primaryFixed,
          width: 2,
        ),
      ),
      counterText: "$remaining characters remaining",
      counterStyle: TextStyle(
        color: Theme.of(context).colorScheme.primaryFixed,
      ),
    );
  }
}
