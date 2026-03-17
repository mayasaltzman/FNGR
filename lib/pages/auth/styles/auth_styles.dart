import 'package:flutter/material.dart';

//styles for the page
abstract class LogInStyles {
  static BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryFixed,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryFixed,
          width: 1,
        ));
  }

  static ButtonStyle buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondaryFixed,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  static TextStyle boxHeader(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 50);
  }

  static TextStyle instructionText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.primaryFixed,
        fontSize: 16);
  }

  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.secondaryFixed,
        fontSize: 16);
  }

  static TextStyle linkText(BuildContext context) {
    return TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: Theme.of(context).colorScheme.primaryFixed,
      color: Theme.of(context).colorScheme.primaryFixed,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.symmetric(vertical: 1, horizontal: 8);
}