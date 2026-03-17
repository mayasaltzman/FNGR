import 'package:flutter/material.dart';

//styles for the page
abstract class ProfileStyles {
  //styles for boxes that store profile info

  static BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryFixed,
          width: 1,
        ));
  }

  //styles for boxes that are individual items in sexual preferences and interests
  static BoxDecoration itemBoxDecoration = BoxDecoration(
      color: const Color(0xFFF9E7F2),
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xFFAA4E85),
        width: 1,
      ));

  //text styles for headings in boxes
  static TextStyle boxHeader(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primaryFixed,
        fontSize: 16);
  }

  static TextStyle boxText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.primaryFixed,
        fontSize: 16);
  }

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}
