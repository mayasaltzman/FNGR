import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/image_button_widget.dart';
import 'dart:io';
import './profile_additional_page.dart';
import './styles/create_profile_styles.dart';

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
            title:
                Text("Photo Tips", style: ProfileStyles.dialogueText(context)),
            content: SizedBox(
              height: ProfileStyles.dialogueHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Insert photo tips here",
                      style: ProfileStyles.dialogueText(context)),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                    Text('Close', style: ProfileStyles.dialogueText(context)),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text("Create Profile",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: BackButton(
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(ProfileStyles.formPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("Add some photos for people to get a sense of who you are:",
                  style: ProfileStyles.pageHeader(context)),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ImageButton(
                            image: _selectedImages[1], onTap: () => () {}),
                        const SizedBox(height: 10),
                        ImageButton(
                            image: _selectedImages[2], onTap: () => () {}),
                      ],
                    ),
                    Column(
                      children: [
                        ImageButton(
                            image: _selectedImages[3], onTap: () => () {}),
                        const SizedBox(height: 10),
                        ImageButton(
                            image: _selectedImages[4], onTap: () => () {}),
                      ],
                    ),
                  ]),
              TextButton(
                onPressed: () {
                  showDialogBox(context);
                },
                style: ProfileStyles.textButton(context),
                child: Text("Photo Tips"),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileAdditionalPage()),
                        );
                      },
                      label: Text("Skip"),
                      icon: Icon(Icons.arrow_forward_ios),
                      iconAlignment: IconAlignment.end,
                      style: ProfileStyles.nextButton(context)))
            ],
          ),
        ));
  }
}
