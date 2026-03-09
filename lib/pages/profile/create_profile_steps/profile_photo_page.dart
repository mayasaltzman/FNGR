import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_button_widget.dart';
import 'dart:io';

//make elements on this page mandatory for an account when doing backend
//the rest of elements on other pages can be skippable
class ProfilePhotoPage extends StatelessWidget {
  ProfilePhotoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<File?> _selectedImages = List.filled(5, null);

    Future showDialogBox(BuildContext context) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Photo Tips",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryFixed)),
            content: SizedBox(
              height: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Insert photo tips here",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryFixed)),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('Close',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryFixed)),
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text("Add some photos for people to get a sense of who you are:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ImageButton(image: _selectedImages[1], onTap: () => () {}),
                    const SizedBox(height: 10),
                    ImageButton(image: _selectedImages[2], onTap: () => () {}),
                  ],
                ),
                Column(
                  children: [
                    ImageButton(image: _selectedImages[3], onTap: () => () {}),
                    const SizedBox(height: 10),
                    ImageButton(image: _selectedImages[4], onTap: () => () {}),
                  ],
                ),
              ]),
          TextButton(
            onPressed: () {
              showDialogBox(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primaryFixed,
              textStyle: const TextStyle(
                  decoration: TextDecoration.underline, fontSize: 20),
            ),
            child: Text("Photo Tips"),
          ),
          Spacer(),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Skip"),
                  icon: Icon(Icons.arrow_forward_ios),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAA4E85),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  )))
        ],
      ),
    );
  }
}
